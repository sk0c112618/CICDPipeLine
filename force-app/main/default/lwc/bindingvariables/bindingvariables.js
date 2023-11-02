import { LightningElement } from 'lwc';

export default class Bindingvariables extends LightningElement {
    newVar = 'World';
    varcheckbox;
    values = 'inProgress';

    get options() {
        return [
            { label: 'New', value: 'new' },
            { label: 'In Progress', value: 'inProgress' },
            { label: 'Finished', value: 'finished' },
        ];
    }


    // text field
    changehandler(event){
        let name = event.target.name;
        let value = event.target.value;

        if(name=='text'){
            this.newVar = value;            
        }else if(name == 'checkbox'){
            this.varcheckbox = event.target.checked;
        }else if(name == 'picklist'){
            this.values =  event.detail.value;
        }
    }
}