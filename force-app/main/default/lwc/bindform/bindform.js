import { LightningElement } from 'lwc';

export default class Bindform extends LightningElement {
    ShowMe = false;
    myValue = "World";
    changeHandler(event){
        this.ShowMe = event.target.checked;
    }
}