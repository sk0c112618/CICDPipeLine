import { LightningElement } from 'lwc';

export default class Createform extends LightningElement {
    names;
    DateofBirth;
    check;

    changeHandler(event){
        let name = event.target.name;

        if(name == 'Name'){
            this.names = event.target.value;
        }else if (name == 'Dob'){
            this.DateofBirth = event.target.value;
        }else if (name == 'Checkbox'){
            this.check = event.target.checked;
        }
        
    }
    handleInputFocus(event){
        const classList = event.target.parentNode.classList;
        classList.add('lgc-highlight');
    }
    handleInputBlur(event){
        const classList = event.target.parentNode.classList;
        classList.remove('lgc-highlight');
    }
}