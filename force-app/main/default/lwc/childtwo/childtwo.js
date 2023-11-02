import { LightningElement } from 'lwc';

export default class Childtwo extends LightningElement {
    searchkey;
    handleChange(event){
        this.searchkey = event.target.value;

        // Create a dispach Event
        const searchEvent = new CustomEvent("getsearchvalue",{
            detail: this.searchkey
        });

        // Dispatch the Event.
        this.dispatchEvent(searchEvent);
    }
}