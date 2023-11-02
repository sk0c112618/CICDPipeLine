import { LightningElement } from 'lwc';

export default class ParentOne extends LightningElement {
   greeting;

    changeHandler(event){
        this.greeting = event.target.value;
       
    }
}