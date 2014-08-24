var Transaction =  function(argument) {
  var self = this;
  var receiptRows = 1;

  var reciptsDone = false;
  var customerDone = false;

  var disableReciptRow = function(num){
    $("#StoreName-"+num).attr('disabled','disabled');
    $("#BillNo-"+num).attr('disabled','disabled');
    $("#Amount-"+num).attr('disabled','disabled');
  }

  var enableReciptRow = function(num){
    $("#StoreName-"+num).removeAttr('disabled');
    $("#BillNo-"+num).removeAttr('disabled');
    $("#Amount-"+num).removeAttr('disabled');
  }

  var addNewReceiptRow = function(){
    var newRow = $($(".receipt-form-template").clone());
    newRow.appendTo("#ReceiptForms");
    newRow.removeClass('receipt-form-template');
    newRow.addClass('receipt-form');
    
    newRowNum = receiptRows + 1;
    newRow.find(".store-name").attr("id","StoreName-"+newRowNum);
    newRow.find(".amount").attr("id","Amount-"+newRowNum); 
    newRow.find(".bill-no").attr("id","BillNo-"+newRowNum);
    var isToday =  newRow.find(".is-today");
    isToday.attr("id","isToday-"+newRowNum);
    bindToChange(isToday);

    newRow.removeClass('hide');
  }

  var bindToChange = function(elem) {
    elem.change(function(){
      element = $(this);
      num =  parseInt(element.attr('id').split("-")[1]);

      if(element.find(":selected").val() == "yes"){
        if(num == receiptRows){
          addNewReceiptRow();
          receiptRows++;
        }
        enableReciptRow(num);
      } else {
        disableReciptRow(num);
      }
    });
  }
 
  var enableDisableSaveButton = function(){
    if(reciptsDone && customerDone) {
      $("#Save").removeAttr("disabled");
    } else {
      $("#Save").attr('disabled','disabled');
    }
  }
  var generateVoucherFields = function(){
    voucherForms = $("#VoucherForms");
    voucherForms.empty();
    var total = 0;
    $(".amount").each(function(){
      var value = $(this).val().trim();
      if(value != ""){
        total = total + parseInt(value);  
      }
    });
    var numRows = total /1000;
    for (var i = 0; i < numRows; i++) {
      var newRow = $($(".voucher-form-template").clone());
      newRow.appendTo(voucherForms);
      newRow.removeClass('voucher-form-template');
      newRow.addClass('voucher-form');
      newRow.removeClass('hide');
    } 
    $("#VoucherDetailsSection").removeClass("hide");
  }

  var initReceipts = function(){
    bindToChange($("#IsToday-1"));
    $("#DoneReceipts").click(function(){
      $("#EditReceipts").removeClass("hide");
      $("#ReceiptForms").find(".rcontrol").attr('disabled','disabled');
      generateVoucherFields();
      $(this).addClass("hide");
      reciptsDone = true;
      enableDisableSaveButton();
    });

    $("#EditReceipts").click(function(){
      $("#DoneReceipts").removeClass("hide");
      $("#ReceiptForms").find(".rcontrol").removeAttr('disabled');
      $("#ReceiptForms").find(".is-today").change();
      $("#VoucherDetailsSection").addClass("hide");
      $(this).addClass("hide");
      reciptsDone = false;
      enableDisableSaveButton();
    });

    $('.typeahead').typeahead({
      hint: false,
      highlight: true,
      minLength: 1
    },
    {
      name: 'stores',
      displayKey: 'value',
      source: function(q, cb){return cb([]);},
      templates: {
          empty: [
            '<div class="empty-message">',
            'unable to find any Best Picture winners that match the current query',
            '</div>'
          ].join('\n')
        }
    });
  }

  var stores = [{value: "Foo"},{value: "bar"}, {value: "baz"}];

  var initCustomer = function(){
    $("#GetCustomer").click(function(){
      $.ajax({
        type: "GET",
        url: "/customers/"+$(".mobile").val().trim(),
        success: function(data){
          console.log(data);
          $(".name").val(data["name"]);
          $(".email").val(data["email"]);
          $(".gender").val(data["gender"]);
          $(".age").val(data["age"]);
          $(".occupation").val(data["occupation"]);
          $(".address").val(data["address"]);
          $("#CustomerData").removeClass("hide");
        },
        error: function(data){
          $("#CustomerData").removeClass("hide");
        },
      })
    });

    $("#DoneCustomer").click(function(){
      $("#EditCustomer").removeClass("hide");
      $(".ccontrol").attr('disabled','disabled');
      $(this).addClass("hide");
      customerDone = true;
      enableDisableSaveButton();
    })
    $("#EditCustomer").click(function(){
      $("#DoneCustomer").removeClass("hide");
      $(".ccontrol").removeAttr('disabled');
      $(this).addClass("hide");
      customerDone = false;
      enableDisableSaveButton();
    });
  }

  self.init = function(){
      initReceipts();
      initCustomer();
      $("#Reset").click(function(){location.reload();});
      $("#Save").click(function(){

        var receiptInfo = [];
        var receiptForms = $(".receipt-form");
        $(receiptForms).each(function(){
          var storeName =  $(this).find(".store-name").val();
          var amount =  $(this).find(".amount").val(); 
          var billNo =  $(this).find(".bill-no").val(); 
          var isToday =  $(this).find(".is-today").find(":selected").val();
          if(isToday == "yes"){
            isToday = true;
          }else{
            isToday = false;
          }
          if(isToday){
            receiptInfo.push({"storeName": storeName, "amount":amount, "billNo": billNo, "isToday":isToday});
          }
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
          var voucherCode =  $(this).find(".voucher-code").val(); 
          voucherInfo.push({"barCode": voucherCode});
        });

        
        var transactionInfo = {
          "receiptInfo" : receiptInfo,
          "customerInfo" : customerInfo,
          "voucherInfo" : voucherInfo
        };

        console.log(transactionInfo.toString());
        
        $.ajax({
          type: "POST",
          url: "/transactions",
          data: JSON.stringify(transactionInfo),
          success: function(data){
            alert("yaay!!!");
          },
          error: function(data){
            alert("booooo!!!");
          },
        })

      });
  }
    
}

$(document).ready(function(){
  var t = new Transaction();
  t.init();  
})
