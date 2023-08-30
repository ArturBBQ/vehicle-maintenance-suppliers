import { LightningElement, api } from 'lwc';

import Next from '@salesforce/label/c.Next';
import Prev from '@salesforce/label/c.Prev';

export default class Pagination extends LightningElement {

    label = {
        Next,
        Prev
    };

    @api recordsPerPage;
    @api totalRecords;
    pageNo = 1;
    totalPages;
    pageNumbers = [];    
    
    connectedCallback(){
        this.calculateTotalPages();
        this.pageNumbersList();
    }      
    
    calculateTotalPages(){
        this.totalPages = Math.ceil(Number(this.totalRecords)/Number(this.recordsPerPage)); 
    } 

    pageNumbersList(){
        this.pageNumbers = Array(this.totalPages).fill().map((event, i) => {
            return {
                pageNumber: i + 1,
                isActive: i + 1 === this.pageNo
            };
        });
    }

    preparePaginationList(){
        this.pageNumbersList();
        let start = (this.pageNo-1)*this.recordsPerPage;
        let end = start + this.recordsPerPage;

        this.dispatchEvent(CustomEvent('pagination', {
            detail:{ 
                start, end 
            }
        }))
    }

    prevHandler(){
        this.pageNo = this.pageNo-1;
        this.preparePaginationList();
    }

    nextHandler(){
        this.pageNo = this.pageNo+1;
        this.preparePaginationList();
    }

    handlePage(event){
        const selectedPage = event.target.label;
        if (selectedPage !== this.pageNo) {
            this.pageNo = Number(selectedPage);
            this.preparePaginationList();
        }
    }

    get disablePrev(){ 
        return this.pageNo <= 1;
    }

    get disableNext(){
        return this.pageNo >= this.totalPages;
    }

}