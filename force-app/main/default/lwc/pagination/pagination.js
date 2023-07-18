import { LightningElement, api } from 'lwc';

export default class Pagination extends LightningElement {

    @api recordsPerPage;
    @api totalRecords;
    pageNo = 1;
    totalPages;
    pageNumbers = [];
    
    
    connectedCallback(){
        this.calculateTotalPages();
    }      
    
    calculateTotalPages(){
        this.totalPages = Math.ceil(Number(this.totalRecords)/Number(this.recordsPerPage)); 
        this.pageNumbers = Array(this.totalPages).fill().map((event, i) => i + 1);
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
        this.pageNo = Number(event.target.label);
        this.preparePaginationList();
    }

    preparePaginationList(){
        let start = (this.pageNo-1)*this.recordsPerPage;
        let end = start + this.recordsPerPage;

        this.dispatchEvent(CustomEvent('pagination', {
            detail:{ 
                start, end 
            }
        }))
    }

    get disablePrev(){ 
        return this.pageNo <= 1;
    }

    get disableNext(){ 
        return this.pageNo >= this.totalPages;
    }

}