var Transaction =  function(argument) {
  var self = this;
  var receiptRows = 1;

  var reciptsDone = false;
  var customerDone = false;
  var vouchersDisabled = false;
  var stores = JSON.parse($("#AllStores").val());

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
    var storeName = newRow.find(".store-name");
    storeName.attr("id","StoreName-"+newRowNum);
    newRow.find(".amount").attr("id","Amount-"+newRowNum); 
    newRow.find(".bill-no").attr("id","BillNo-"+newRowNum);
    var isToday =  newRow.find(".is-today");
    isToday.attr("id","isToday-"+newRowNum);
    bindToChange(isToday);
    hookTypeahead(storeName);
    newRow.validate();
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
  var generateVoucherFields = function(total){
    voucherForms = $("#VoucherForms");
    voucherForms.empty();
   
    var numRows = parseInt(total /1000);
    for (var i = 0; i < numRows; i++) {
      var newRow = $($(".voucher-form-template").clone());
      newRow.appendTo(voucherForms);
      newRow.removeClass('voucher-form-template');
      newRow.addClass('voucher-form');
      newRow.removeClass('hide');

    } 
    
    $("#VoucherDetailsSection").removeClass("hide");
  }

  var generateTotal = function(){
    var total = 0;
    $(".amount").each(function(){
      var value = $(this).val().trim();

      if( value != "" && !($(this).attr("disabled") == "disabled") ){
        total = total + parseInt(value);  
      }
    });
    return total;
  }

  var substringMatcher = function(strs) {
    return function findMatches(q, cb) {
      var matches, substrRegex;
      matches = [];
      substrRegex = new RegExp(q, 'i');
      $.each(strs, function(i, str) {
        if (substrRegex.test(str)) {
          matches.push({ value: str });
        }
      });
      cb(matches);
    };
  };

  var hookTypeahead = function(element) {
    // return;
    element.typeahead({
      hint: false,
      highlight: true,
      minLength: 1
    },
    {
      name: 'stores',
      displayKey: 'value',
      source: substringMatcher(stores)
    });
  }

  var initReceipts = function(){
    bindToChange($("#IsToday-1"));
    $("#DoneReceipts").click(function(){
      $("#TotalLess").addClass("hide");
      var total = generateTotal();
      $("#Total").empty();
      $("#Total").html(total);
      var isValid = true;
      $(".receipt-form").each(function(){
        $(this).find("input").each(function(){
          if(!$(this).attr("disabled")){
            isValid = $(this).valid() && isValid;
          }
        });
      });
      if(total < 1000){
        $("#TotalLess").removeClass("hide");
        // $("#TotalLess").show();
        isValid = false;
      }

      if(!isValid) return;

      $("#EditReceipts").removeClass("hide");
      $(".mobile").focus();
      
      generateVoucherFields(total);
      

      $("#ReceiptForms").find(".rcontrol").attr('disabled','disabled');
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

    hookTypeahead($('.typeahead'));
  }

  var disableVouchersForWinner = function(){
    vouchersDisabled = true;
    $(".voucher-code").attr("disabled","disabled"); 
  }

  var enableVouchers = function(){
    $(".voucher-code").removeAttr("disabled"); 
  }

  var resetCustomerForm = function(){
    vouchersDisabled = false;
    enableVouchers();
    $(".name").val("");
    $(".email").val("");
    $(".gender").val("");
    $(".age").val("");
    $(".occupation").val("");
    $(".address").val("");
  }

  var initCustomer = function(){
    $("#GetCustomer").click(function(){
      resetCustomerForm();
      if(!$(".mobile").valid()) return;

      $.ajax({
        type: "GET",
        url: "/customers/"+$(".mobile").val().trim(),
        cache: false,
        success: function(data){
          console.log(data);
          var isWinner = data["is_winner?"];
          if(isWinner) {
            disableVouchersForWinner();
          }
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
      var isValid = true;
      $(".customer-form").each(function(){
        $(this).find("input").each(function(){
          if(!$(this).attr("disabled")){
            isValid = $(this).valid() && isValid;
          }
        });
      });

      if(!isValid) return;

      $("#EditCustomer").removeClass("hide");
      $(".ccontrol").attr('disabled','disabled');
      $(this).addClass("hide");
      customerDone = true;
      enableDisableSaveButton();
    });

    $("#EditCustomer").click(function(){
      $("#DoneCustomer").removeClass("hide");
      $(".ccontrol").removeAttr('disabled');
      $(this).addClass("hide");
      customerDone = false;
      enableDisableSaveButton();
    });
  }

  self.init = function(){
      $.validator.addMethod("store-name", function(value, element) {
        return ($.inArray(value, stores) != -1);
      }, "Enter valid store name.");


      initReceipts();
      initCustomer();
      $("#Reset").click(function(){location.reload();});
      $("#Save").click(function(){

        var isValid = true;
        $(".voucher-form").each(function(){
          $(this).find("input").each(function(){
            if(!$(this).attr("disabled")){
              isValid = $(this).valid() && isValid;
            }
          });
        });
        if(!isValid) return;

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

        if(!vouchersDisabled) {
          var voucherInfo = []
          var voucherForms = $(".voucher-form");
          $(voucherForms).each(function(){
            var voucherCode =  $(this).find(".voucher-code").val(); 
            voucherInfo.push({"barCode": voucherCode.trim()});
          });
        }

        
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
            location.reload();
          },
          error: function(data){
            var msg = "";
            response = data.responseJSON
            $(response).each(function(){
              msg = msg + this+"<br/>"
            });
            $("#Errors").empty();
            $("#Errors").html(msg);
            $("#Errors").removeClass("hide");
          }
        })
      });
  }
    
}

$(document).ready(function(){
  if($(".new-transaction").length != 0){
    var t = new Transaction();
    t.init();    
  }
})
