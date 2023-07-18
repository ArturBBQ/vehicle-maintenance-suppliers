import { api } from 'lwc';
import LightningModal from 'lightning/modal';
import bookAppointment from '@salesforce/apex/AccountSuppliersController.bookAppointment';

export default class BookAppointmentModal extends LightningModal {

    @api accountId;
    @api supplierId;
    appointmentTime;
    status = 'New';
    caseOrigin = 'Phone';
    showErrorMessage = false;

    closeModal() {
        this.close();
    }

    handleInput(event) {
        this.appointmentTime = event.target.value;
    }

    handleBookAppointment(){
        bookAppointment({
            accountId: this.accountId,
            supplierId: this.supplierId,
            status: this.status,
            caseOrigin: this.caseOrigin,
            appointmentTime: this.appointmentTime
        }) .then((result) => {
            if(result != null){
                this.close( { result: result } );
            } else {
                this.showErrorMessage = true;
            }
           
        })
        .catch((error) => {
            console.error(error);
        })
    }

}