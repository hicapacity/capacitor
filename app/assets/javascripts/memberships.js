$(document).ready(function() {
  var bootstrapValidator = 
  $('#paymentForm').bootstrapValidator({
    message: 'This value is not valid',
    fields: {
      'plan': {
        validators: {
            notEmpty: {
                message: 'The plan is required'
            }
        }
      },
      cardholderName: {
        message: 'The cardholder name is not valid',
        validators: {
          notEmpty: {
            message: 'The cardholder name is required'
          }
        }
      },
      cardNumber: {
        validators: {
          creditCard: {
            message: 'A valid credit card number is required'
          },
          notEmpty: {
            message: 'Credit card number is requied'
          }
        }
      },
      cvc: {
        validators: {
          cvv: {
            creditCardField: 'cardNumber',
            message: 'The CVC number is not valid'
          },
          notEmpty: {
              message: 'The CVC code is required'
          }
        }
      },
      expiration: {
        validators: {
          callback: {
            message: 'Invalid expiration date',
            callback: function (value, validator) {
              var m = new moment(value, 'MM/YY', true);
              
              valid = false;
              if (m.isValid()) {
                // format is valid
                var now = moment(); // get now
                if (m.year() > now.year()) {
                  valid = true;
                }
                else if (m.year() == now.year()) {
                  valid = m.month() >= now.month()
                }      
              }
              return valid;
            }
          },
          // notEmpty: {
          //     message: 'The card expiration date is required'
          // }
        }
      }
    }
  });
  
  // this disables success coloring (from the bootstrap validator page)
  bootstrapValidator.on('success.field.bv', function(e, data) {
      // $(e.target)  --> The field element
      // data.bv      --> The BootstrapValidator instance
      // data.field   --> The field name
      // data.element --> The field element

      var $parent = data.element.parents('.form-group');

      // Remove the has-success class
      $parent.removeClass('has-success');

      // Hide the success icon
      $parent.find('.form-control-feedback[data-bv-icon-for="' + data.field + '"]').hide();
  });
  
  // force validators to run
  bootstrapValidator.bootstrapValidator('validate');
});