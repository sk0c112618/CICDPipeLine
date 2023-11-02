import { LightningElement,track } from 'lwc';
import GetTallyData from '@salesforce/apex/TallyDataProcess.GetTallyData';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class TallyData extends LightningElement {

    @track Spinner = true;
    connectedCallback(){
        this.tallyData();
    }

    tallyData(){
        GetTallyData()
        .then(result => {
            const event = new ShowToastEvent({
                title: 'Success',
                message: 'Your Data Imported Successfully',
                variant: 'success',
                mode: 'dismissable'
            });
            this.dispatchEvent(event);
            console.log('result'+JSON.stringify(result));
            this.Spinner = false;
            this.dispatchEvent(new CloseActionScreenEvent());
           
        })
        
        .catch(error => {
            
            this.error = error;
            this.dispatchEvent(new CloseActionScreenEvent());
            
        });
        
    } 
    
}