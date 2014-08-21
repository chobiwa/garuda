var Transaction =  function(argument) {

  var self = this;

  self.init = function(){
      
      $("#Save").click(function(){

        var receiptInfo = [];
        var receiptForms = $(".receipt-form");
        $(receiptForms).each(function(){
          var storeName =  $(this).find(".store-name").val() 
          var amount =  $(this).find(".amount").val() 
          var billNo =  $(this).find(".bill-no").val() 
          var isToday =  $(this).find(".is-today").val() 
          if(isToday == "Yes"){
            isToday = true;
          }else{
            isToday = false;
          }
          receiptInfo.push({"storeName": storeName, "amount":amount, "billNo": billNo, "isToday":isToday});
        });

        var customerInfo = {
          "mobile" : $(".mobile").val(),
          "name" : $(".name").val(),
          "email" : $(".email").val(),
          "gender": $(".gender").val(),
          "age": $(".age").val(),
          "occupation": $(".occupation").val(),
          "address": $(".address").val()
        }

        var voucherInfo = []
        var voucherForms = $(".voucher-form");
        $(voucherForms).each(function(){
          var barCode =  $(this).find(".bar-code").val() 
          var scratchCode =  $(this).find(".scratch-code").val() 

          voucherInfo.push({"barCode": barCode, "scratchCode":scratchCode});
        });

        
        var transactionInfo = {
          "receiptInfo" : receiptInfo,
          "customerInfo" : customerInfo,
          "voucherInfo" : voucherInfo
        };

        console.log(transactionInfo.toString());

      });
  }
    
}


var t = new Transaction();
t.init();