import { LightningElement, track } from 'lwc';

export default class Parenttwo extends LightningElement {
    @track searchValue;
    handleSearchValue(event){
        this.searchValue = event.detail;
    }
}