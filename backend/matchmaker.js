class Matchmaker{
    #queue = [];

    constructor(){
        this.#queue = [];
    }

    addPlayer(player){
        this.#queue.push(player);
    }

    removePlayer(player){
        this.#queue.splice(this.#queue.indexOf(player), 1);
    }

    canMatch(){
        return this.#queue.length >= 2;
    }

    peek(){
        return this.#queue[0];
    }
}

module.exports =  Matchmaker;