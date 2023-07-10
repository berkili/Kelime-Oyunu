const admin = require('firebase-admin');
const http = require('http');
const socketIO = require('socket.io');
const serviceAccount = require('./config/spinning-quiz-firebase-adminsdk-i118m-4fea880ca2.json');

const Match = require('./match.js');
const Matchmaker = require('./matchmaker.js');
const Game = require('./game.js');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://spinning-quiz.firebaseio.com",
});

const server = http.createServer((req, res) => {
  res.end('Merhaba Dünya!');
});

const io = socketIO(server);

const matchmaker = new Matchmaker();
const matches = []


io.on('connection', (socket) => {
  console.log('Yeni bir kullanıcı bağlandı.');

  socket.on('authenticate', async (obj) => {
    try {
      const { token } = obj;

      const doc = await admin.firestore().collection('login').doc(token).get()
      if (!doc.exists) {
        socket.emit('authenticated', { success: false, message: 'Token bulunamadı' },);
        return;
      }
      const data = doc.data();
      const { used, userId, userName } = data;

      if (used) {
        socket.emit('authenticated', { success: false, message: 'Token kullanılmış' },);
        return;
      }

      await admin.firestore().collection('login').doc(token).update({ used: true });
      socket.data.userId = userId;
      socket.data.userName = userName;
      socket.emit('authenticated', { success: true, message: 'Token v kullanıldı' },);

    }
    catch (e) {
      socket.emit('authenticated', { success: false, message: 'Giriş yapılırken hata oluştu.' },);
    }
  });

  socket.on("queue", () => {
    matchmaker.addPlayer(socket);

    if (matchmaker.canMatch()) {
      const player1 = matchmaker.peek();
      matchmaker.removePlayer(player1);
      const player2 = matchmaker.peek();
      matchmaker.removePlayer(player2);

      const gameId = require('crypto').randomUUID();
      const matchId = require('crypto').randomUUID();
      
      const game = new Game(gameId, player1, player2);
      const match = new Match(matchId, new Date().toISOString(), player1, player2);

      matches.push(match);

      game.start();
    }
  });

  socket.on('dequeue', () => {
    matchmaker.removePlayer(socket);
  });  
  

  socket.on('disconnect', async () => {
    console.log('Bir kullanıcı ayrıldı.');
    matchmaker.removePlayer(socket);
  });
});

server.listen(3000, '0.0.0.0', () => {
  console.log('Sunucu çalışıyor: http://localhost:3000');
});

module.exports = io;
