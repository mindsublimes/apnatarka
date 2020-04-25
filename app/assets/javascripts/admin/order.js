$(document).ready(function(){
  $('body').on('change', '.order-category', function(){
    var order_category = $(this)
    var category = $(this).val();
    $.ajax({
      type: 'GET',
      url: '/admin/orders/order_items',
      dataType: 'json',
      data: {category: category}, 
      success: function(data){
        var $mySelect = order_category.closest('.form-group').siblings('.order-item').find('.menu_item')
        jQuery.each(data, function(index, value) {
          var $option = $("<option/>", {
          value: value[0],
          text: value[1]
          });
          $mySelect.append($option);
        });
      }
    });
  });
  // $('.order-category').on('change', function(){
    
  // }); 

  $('body').on('change', '.order-menu-item' , function(){
    var order_menu_item = $(this)
    var menu_item = $(this).val().split(',')[0]
    $.ajax({
      type: 'GET',
      url: '/admin/orders/order_chefs',
      dataType: 'json',
      data: {menu_item: menu_item}, 
      success: function(data){
        var $mySelect = order_menu_item.closest('.form-group').siblings('.select-chef').find('.chef')
        jQuery.each(data, function(index, value) {
        var $option = $("<option/>", {
          value: value[0],
          text: value[1]
        });
        $mySelect.append($option);
      });
      }
     });
  }); 

  $('body').on('focusout', '#check-phone', function(){
    var phone = $(this).val();
    if (phone != "") {
      $.ajax({
        url: '/admin/orders/checkemail',
        method: 'GET',
        data: {phone: phone}
      })
    } else {
      $('#email-availability').html('');
    }
  });

  $('.collapsible').on('click', function(){
    var coll = document.getElementsByClassName("collapsible");
    var i;

    for (i = 0; i < coll.length; i++) {
      coll[i].addEventListener("click", function() {
        this.classList.toggle("active");
        var content = this.nextElementSibling;
        if (content.style.display === "block") {
          content.style.display = "none";
        } else {
          content.style.display = "block";
        }
      });
    }
  });

  $('.country-states').on('change', function(){
    var state = $(this).val();
    $.ajax({
      type: 'GET',
      url: '/admin/orders/check_cities',
      dataType: 'json',
      data: {state: state}, 
      success: function(data){
        var $mySelect = $('.cities');
        jQuery.each(data, function(index, value) {
        var $option = $("<option/>", {
          value: value,
          text: value
        });
        $mySelect.append($option);
      });
      }
     });
  }); 

  $('body').on('change', '.menu_item' , function(){
    menu_item = $(this).val();
    $.ajax({
      type: 'GET',
      url: '/admin/orders/menu_item',
      dataType: 'json',
      data: {menu_item: menu_item}, 
      success: function(data){
        menu_item_price = data
      }
     });
  });

  $('body').on('focusout', '.order-quantity' ,function (){
    
    if ( $('.display-total').val() != ""){ amount = parseFloat($('.display-total').val()) } else{amount = 0}
    quantity = $(this).val();
    total_amount = parseFloat(quantity) * parseFloat(menu_item_price)
    $(this).closest('.form-group').siblings('.total').find('.total-amount').val(total_amount);
    gst_value = $('.gst').text().split(" ")[3]
    gst = parseFloat(gst_value) / 100
    total = total_amount
    amount += parseFloat(total) + (parseFloat(total) * parseFloat(gst) )
    $('.display-total').val(amount);
  });

  $('#check-phone').on('keyup', function(){
    phone = $(this).val();
    $('.show-phone').val(phone);
  });

//   $('.total-amount').keyup(function () {
//     // var quantity = $('.order-quantity').val();
//     var total =  $(this).val();
//     var amount = parseFloat(total)
//     amount = amount + ( amount * 0.05 )
//     $('.display-total').val(amount);
// });

  // $('.append-form').on('click', function(){
  //   append_data = $('.collect-data').html();
  //   $('.form-to-append').append(append_data);
  // });

});
