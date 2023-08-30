import { api } from 'lwc';
import LightningModal from 'lightning/modal';
import bookAppointment from '@salesforce/apex/AccountSuppliersController.bookAppointment';

export default class BookAppointmentModal extends LightningModal {

    @api accountId;
    @api supplierId;
    newCaseInput ={};
    status = 'New';
    caseOrigin = 'Phone';
    showErrorMessage = false;
    errorMessage;

    closeModal() {
        this.close();
    }

    handleInput(event) {
        this.newCaseInput[event.target.name] = event.target.value;
    }

    handleBookAppointment(){
        bookAppointment({
            contactId: this.newCaseInput.contactId,
            accountId: this.accountId,
            supplierId: this.supplierId,
            status: this.status,
            caseOrigin: this.caseOrigin,
            appointmentTime: this.newCaseInput.datetime
        }) .then((result) => {
            if(result != null){
                this.close( { result: result } );
            }           
        })
        .catch((error) => {
            console.error(error);
            if (error.body.message) {
                this.showErrorMessage = true;
                this.errorMessage = error.body.message;                
            }
        })
    }

}