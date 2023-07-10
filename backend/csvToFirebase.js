const admin = require("firebase-admin");
const fs = require("fs");
const csv = require("csv-parser");

const serviceAccount = require('./config/spinning-quiz-firebase-adminsdk-i118m-4fea880ca2.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://spinning-quiz.firebaseio.com",
});

const db = admin.firestore();

function aktarCsvFirestore(csvDosya, koleksiyon) {
  fs.createReadStream(csvDosya)
    .pipe(csv())
    .on("data", (data) => {
      const { question, a, b, c, d, answer, question_class } = data;
      const options = [a, b, c, d];
      const answerIndex = answer.charCodeAt(0) - 97;

      db.collection(koleksiyon).add({
        question,
        options,
        answer: answerIndex,
        question_class
      });
    })
    .on("end", () => {
      console.log("Veriler Firestore'a aktarıldı.");
    });
}


const csvDosya = "soru.csv";
const hedefKoleksiyon = "questions";

aktarCsvFirestore(csvDosya, hedefKoleksiyon);