import { LightningElement,wire,track, api } from 'lwc';
import Messages from '@salesforce/apex/SMSMessenger.getSMSMessenges';
import {refreshApex} from '@salesforce/apex';

export default class MessengerPoc extends LightningElement {   
     @track smsMessages; 
     wiredMessages;  

    @wire(Messages) 
    getSMSMessenges(value) {
        
          this.wiredMessages = value;
          const {data, error} = value;

          if(data){
            this.smsMessages = data;
            setInterval(()=>{  
              console.log('in SI');
    
              return refreshApex(this.wiredMessages);  
                
            }, 1000);
          }
    
         else if (error) {
            console.log(error);
            this.error = error;
           
        } ;
      }


    

 
    }