import { LightningElement,api,track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import createCarPartRecordsFromJSON from '@salesforce/apex/CarPartsUploaderController.createCarPartRecordsFromJSON'
import NAME_FIELD from '@salesforce/schema/Car_Part__c.Name';
import PRICE_FIELD from '@salesforce/schema/Car_Part__c.Price__c';
import MANUFACTURER_FIELD from '@salesforce/schema/Car_Part__c.Manufacturer__c';
import CODE_FIELD from '@salesforce/schema/Car_Part__c.Code__c';
import DESCRIPTION_FIELD from '@salesforce/schema/Car_Part__c.Description__c';

 

export default class CarPartUploader extends LightningElement {
    @api recordId;
    fileData;
    @track newCarPartRecords;
    @api newCarPartColumns = [
        {
            label: 'Name',
            fieldName: NAME_FIELD.fieldApiName
        },
        {
            label: 'Price',
            type: 'currency',
            fieldName: PRICE_FIELD.fieldApiName
        },
        {   label: 'MANUFACTURER', 
            fieldName: MANUFACTURER_FIELD.fieldApiName
        },
        {
            label: 'Code',
            fieldName: CODE_FIELD.fieldApiName
        },
        {
            label: 'Description',
            fieldName: DESCRIPTION_FIELD.fieldApiName
        }
    ];

    onFileUpload(event) {
        const file = event.target.files[0]
        var reader = new FileReader()
        reader.onload = () => {
            var base64 = reader.result.split(',')[1]
            this.fileData = {
                'base64': base64
            }
        }
        reader.readAsDataURL(file)
    }
    
    handleClick(){
        const {base64, filename} = this.fileData
        createCarPartRecordsFromJSON({ base64}).then(result=>{
            
            this.newCarPartRecords = result;
            this.fileData = null
            let title = `Car parts from ${filename} created sucessfully !`
            this.showToast(title)
        })
    }

    showToast(title){
        const toastEvent = new ShowToastEvent({
            title, 
            variant:"success"
        })
        this.dispatchEvent(toastEvent)
    }
}