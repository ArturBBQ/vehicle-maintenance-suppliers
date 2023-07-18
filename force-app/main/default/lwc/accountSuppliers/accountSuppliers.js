import { LightningElement, api, wire, track } from 'lwc';
import { getRecord} from 'lightning/uiRecordApi';
import getSuppliersByCity from '@salesforce/apex/AccountSuppliersController.getSuppliersByCity';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const FIELDS = [
    'Account.BillingCity', 
    'Account.BillingStreet',
    'Account.Location__Latitude__s', 
    'Account.Location__Longitude__s'
];

import bookAppointmentModal from "c/bookAppointmentModal";

export default class AccountSuppliers extends LightningElement {

    @api recordId;
    accountCity;
    accountStreet;
    accountLatitude;
    accountLongitude;
    @track mapMarkers = [];
    supplierId;

    //variables for pagination 
    @api recordsPerPage;
    @api numberOfRecords;
    _recordsPerPage;
    startIndex = 0;
    endIndex;


    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    currentAccount({ error, data }) {
        if (data) {
            this.accountCity = data.fields.BillingCity.value;
            this.accountStreet = data.fields.BillingStreet.value;
            this.accountLatitude = data.fields.Location__Latitude__s.value;
            this.accountLongitude = data.fields.Location__Longitude__s.value;

            this.getSuppliersForMap();
        } else {
            console.error(error);
        }
    }

    getSuppliersForMap(){
        getSuppliersByCity({ 
            accountCity :this.accountCity, 
            accountLatitude :this.accountLatitude, 
            accountLongitude :this.accountLongitude 
        })
        .then( (data) => {
            this.mapMarkers = [
                {
                  location: {
                    Latitude: this.accountLatitude,
                    Longitude: this.accountLongitude,
                    Street: this.accountStreet
                  },
                  icon: 'custom:custom26',
                  title: 'Current Customer Address is HERE'
                },
                ...data.map((dataItem) => ({
                  location: {
                    Latitude: dataItem.Location__Latitude__s,
                    Longitude: dataItem.Location__Longitude__s,
                    Street: dataItem.Billing_Address__Street__s
                  },
                  value: dataItem.Id,
                  icon: 'custom:custom108',
                  title: dataItem.Name
                }))
            ];
        }).catch((error) => {
            console.error(error);
        })
    }

    handleMarkerSelect(event) {
        this.supplierId = event.target.selectedMarkerValue;
    }

    handleClick(){
        bookAppointmentModal.open({
            size: 'small',
            supplierId: this.supplierId,
            accountId: this.recordId
        })
        .then((result) => {
            if (result) {
                this.showMessage('Success', 'Appointment booked successfully', 'success');
            }
                
        });
    }

    showMessage(title, message, variant){
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: variant
            })
        );
    }


    //---Pagination---

    handlePagination(event) {
        this.startIndex = event.detail.start;
        this.endIndex = event.detail.end;
    }

    get visibleRecords() {
        if(this.mapMarkers) {
            return this.mapMarkers.slice(this.startIndex, this.endIndex);
        }
    }
    
    get numberOfRecords() {
        if(this.mapMarkers) {
            return this.mapMarkers.length;
        }
    }

    get recordsPerPage() {
        return this._recordsPerPage;
    } 
      
    set recordsPerPage(value) {
        if(value) {
            this._recordsPerPage = value;
            this.endIndex = value;
        }
    }

}