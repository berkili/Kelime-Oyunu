const EventEmitter = require('events');
const admin = require('firebase-admin');

const GAME_STATES = {
    NOT_STARTED: -1,
    INITIAL_TIMEOUT: 0,
    WAITING_ANSWERS_OR_TIMEOUT: 1,
    ROUND_END_TIMEOUT: 2,
    GAME_END: 3
}

const LOG_LEVELS = {
    INFO: "INFO",
    ERROR: "ERROR"
}

const INITIAL_TIMEOUT = 10000;
const ANSWER_TIMEOUT = 15000;
const ROUND_END_TIMEOUT = 5000;
const NUMBER_OF_ROUNDS = 3;

// STATE_MACHINE 
// NOT_STARTED -> INITIAL_TIMEOUT -> (WAITING_ANSWERS_OR_TIMEOUT -> ROUND_END_TIMEOUT) x  NUMBER_OF_ROUNDS -> GAME_END
class Game extends EventEmitter {
    constructor(gameId, player1, player2) {
        super();
        this.gameId = gameId;
        this.player1 = player1;
        this.player2 = player2;

        this.state = GAME_STATES.NOT_STARTED;
        this.questions = [];
        this.playerAnswersPerRound = [];
        this.round = 0;

        this.timeouts = [];
        this.eventListeners = [];
    }

    broadcast(event, data) {
        this.player1.emit(event, data);
        this.player2.emit(event, data);
    }

    async randomSoruAl() {
        const docRef = admin.firestore().collection('questions');

        return await new Promise((resolve, reject) => {
            docRef.get().then((querySnapshot) => {
                const questions = [];
                const classQuestions = { 0: [], 1: [], 2: [], 3: [] };

                querySnapshot.forEach((doc) => {
                    const question = doc.data();
                    questions.push(question);

                    const questionClass = question.question_class;
                    classQuestions[questionClass].push(question);
                });

                const selectedQuestions = [];
                for (let classIndex = 0; classIndex <= 3; classIndex++) {
                    const classQuestionList = classQuestions[classIndex];
                    const randomIndex = Math.floor(Math.random() * classQuestionList.length);
                    const randomQuestion = classQuestionList[randomIndex];
                    selectedQuestions.push(randomQuestion);
                }

                resolve(selectedQuestions);
            }).catch(err => reject(err));
        })
    }

    broadcastMatchStart() {
        this.player1.emit('match', {
            gameId: this.gameId, opponent: {
                userId: this.player2.data.userId,
                userName: this.player2.data.userName,
            },
            INITIAL_TIMEOUT: INITIAL_TIMEOUT
        });
        this.player2.emit('match', {
            gameId: this.gameId, opponent: {
                userId: this.player1.data.userId,
                userName: this.player1.data.userName,
            },
            INITIAL_TIMEOUT: INITIAL_TIMEOUT
        });
    }

    log(level, message) {
        // LOg message by level, current time and gameId
        console.log(`[${level}] [${new Date().toISOString()}] [${this.gameId}] ${message}`);
    }

    clearAllTimeouts() {
        this.timeouts.forEach(timeout => clearTimeout(timeout));
        this.timeouts = [];
    }

    setClerableTimeout(callback, timeout) {
        const timeoutId = setTimeout(callback, timeout);
        this.timeouts.push(timeoutId);

        return timeoutId;
    }

    clearEventListeners(){
        this.eventListeners.forEach(listener => listener.obj.removeListener(listener.event, listener.callback));
    }

    addClearableEventListenerRecord(obj, event, callback) {
        this.eventListeners.push({ obj, event, callback });
    }

    onPlayerDisconnect(player) {
        // TODO: This should be same as onPlayerAnswerTimeout or gameEnd
        this.clearAllTimeouts();
        this.clearEventListeners();

        this.log(LOG_LEVELS.INFO, `Oyuncu ayrıldı. Oyuncu id: ${player.data.userId}`);

        this.broadcast('playerDisconnect', { userId: player.data.userId });
        this.state = GAME_STATES.GAME_END;
    }

    onGameEnd(){
        this.log(LOG_LEVELS.INFO, 'Oyun bitti.');
        this.clearEventListeners();

        const player1CorrectAnswers = this.playerAnswersPerRound.reduce((acc, val,i) => acc + (val.player1 == null ? 0 : this.questions[i].answer == val.player1 ? 1 : 0), 0);
        const player2CorrectAnswers = this.playerAnswersPerRound.reduce((acc, val,i) => acc + (val.player2 == null ? 0 : this.questions[i].answer == val.player2 ? 1 : 0), 0);
        this.state = GAME_STATES.GAME_END;


        if(player1CorrectAnswers == player2CorrectAnswers){
            this.broadcast('gameEnd', { sonuc: -1 });
        }
        else if(player1CorrectAnswers > player2CorrectAnswers){
            this.player1.emit('gameEnd', { sonuc: 1});
            this.player2.emit('gameEnd', { sonuc: 0});
        }
        else{
            this.player1.emit('gameEnd', { sonuc: 0});
            this.player2.emit('gameEnd', { sonuc: 1});
        }

        this.emit('end');
    }

    onRoundEndTimeoutEnd() {
        this.log(LOG_LEVELS.INFO, `Round end timeout bitti. Round: ${this.round}`);

        this.broadcast('roundEndTimeoutEnd', { round: this.round });

        this.round++;

        this.onRoundStart();
    }

    onRoundEnd(){
        this.log(LOG_LEVELS.INFO, `Round bitti. Round: ${this.round}`);

        if(this.round + 1 === NUMBER_OF_ROUNDS){
            this.onGameEnd();
            return;
        }

        this.state = GAME_STATES.ROUND_END_TIMEOUT;

        this.broadcast('roundEnd', { round: this.round, TIMEOUT: ROUND_END_TIMEOUT });

        const roundTimeoutId = this.setClerableTimeout(() => (this.onRoundEndTimeoutEnd()), ROUND_END_TIMEOUT);
    }

        onRoundStart() {
        this.log(LOG_LEVELS.INFO, `Round başladı. Round: ${this.round}`);

        this.state = GAME_STATES.WAITING_ANSWERS_OR_TIMEOUT;

        this.broadcast('roundStart', { round: this.round, question:{
            question: this.questions[this.round].question,
            options: this.questions[this.round].options,
            question_class: this.questions[this.round].question_class
        },ANSWER_TIMEOUT });

        let answerCount = 0;

        function clearEventListeners() {
            this.player1.off('answer', onPlayer1Answer);
            this.player2.off('answer', onPlayer2Answer);
        }

        const self = this;
        
        function onPlayer1Answer(data) {
            answerCount++;

            self.log(LOG_LEVELS.INFO, `Player 1 cevap verdi. Round: ${self.round}, Cevap: ${data.index}`);
            self.playerAnswersPerRound[self.round]["player1"] = data.index;
            if (answerCount === 2) {
                clearTimeout(roundTimeoutId);
                clearEventListeners.call(self);
                self.onRoundEnd();
            }
        }

        function onPlayer2Answer(data) {
            answerCount++;
            self.playerAnswersPerRound[self.round]["player2"] = data.index;

            self.log(LOG_LEVELS.INFO, `Player 2 cevap verdi. Round: ${self.round}, Cevap: ${data.index}`);
            if (answerCount === 2) {
                clearTimeout(roundTimeoutId);
                clearEventListeners.call(self);
                self.onRoundEnd();
            }
        }

        const roundTimeoutId = this.setClerableTimeout(() => (clearEventListeners.call(this), this.onRoundEnd()), ANSWER_TIMEOUT);

        this.player1.once('answer', onPlayer1Answer);
        this.player2.once('answer', onPlayer2Answer);

        this.addClearableEventListenerRecord(this.player1, 'answer', onPlayer1Answer);
        this.addClearableEventListenerRecord(this.player2, 'answer', onPlayer2Answer);
    }

    onInitialTimeoutEnd() {
        this.log(LOG_LEVELS.INFO, 'Başlangıç zamanı bitti.');

        this.onRoundStart();
    }

    async start() {
        this.player1.join(this.gameId);
        this.player2.join(this.gameId);

        const binded1 = this.onPlayerDisconnect.bind(this, this.player1);
        const binded2 = this.onPlayerDisconnect.bind(this, this.player2);
        
        this.player1.on('disconnect', binded1);
        this.player2.on('disconnect', binded2);

        this.addClearableEventListenerRecord(this.player1, 'disconnect', binded1);
        this.addClearableEventListenerRecord(this.player2, 'disconnect', binded2);

        this.broadcastMatchStart();

        this.log(LOG_LEVELS.INFO, `Oyun başladı. Oyun id: ${this.gameId}`);
        this.state = GAME_STATES.INITIAL_TIMEOUT;

        this.questions = await this.randomSoruAl();
        this.playerAnswersPerRound = Array.from({ length: NUMBER_OF_ROUNDS }, () => ({ player1: null, player2: null }));

        this.log(LOG_LEVELS.INFO, `Sorular alındı. Soru sayısı: ${this.questions.length}`);
        this.log(LOG_LEVELS.INFO, `Başlangıç zamanı beklenmeye başlandı (${INITIAL_TIMEOUT} ms)`);

        this.setClerableTimeout(() => this.onInitialTimeoutEnd(), INITIAL_TIMEOUT);
    }
}

module.exports = Game;
