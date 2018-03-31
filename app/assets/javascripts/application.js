// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require jquery3
//= require popper
//= require bootstrap-sprockets
//= require cocoon
//= require chosen-jquery
//= require bootstrap-datepicker
//= require cloudinary
//= require scaffold
//= require selectize
//= require_tree .


$(document).ready(function() {
  var academic = $('#academic_year');
  if (academic.val() === '') {
    $('#class_name').attr('disabled',true);
  }
  else {
    $('#class_name').removeAttr('disabled');
  };

  $(document).on("change", "#academic_year", function(e){
  $('#class_name').removeAttr('disabled');
  var year = e.target.value;
  $.ajax({
    url: "/api/filters/classes_by_year/?academic_year=" + year,
    type: "GET",
    dataType: "json",
    success: function(data) {
        $('#class_name').html('');
        $('#class_name').append($("<option>Select Class</option>"));
          $.each(data, function(index, value){
            $('#class_name').append('<option value="'+ value +'">'+ value +'</option>');
          });
          console.log(data);
        }
    });
  });

  $('.collapse').on('show.bs.collapse', function () {
    $('.collapse').collapse('hide');
  });

  if($.fn.cloudinary_fileupload !== undefined) {
    $("input.cloudinary-fileupload[type=file]").cloudinary_fileupload();
  }

  $('.cloudinary-fileupload').bind('cloudinarydone', function(e, data) {
    $('.preview').html(
      $.cloudinary.image(data.result.public_id,
        { format: data.result.format, version: data.result.version,
          crop: 'fill', width: 150, height: 150 })
    );
    $('.image_public_id').val(data.result.public_id);
    return true;
  });
  $('.cloudinary-fileupload').bind('fileuploadprogress', function(e, data) {
    $('.progress-bar').css('width', Math.round((data.loaded * 100.0) / data.total) + '%');
  });
});

$(document).ready(function () {
  $('#report-filter #age').selectize({
    delimiter: ',',
    persist: false,
    valueField: 'age',
    labelField: 'age',
    options: [
      {age: '13'},
      {age: '14'},
      {age: '15'},
      {age: '16'},
      {age: '17'},
      {age: '18'},
      {age: '19'},
      {age: '20'},
      {age: '21'},
      {age: '22'},
      {age: '23'}
    ]
  });
  $('#report-filter #gender').selectize({
    delimiter: ',',
    persist: false,
    valueField: 'gender',
    labelField: 'gender',
    options: [
      {gender: 'male'},
      {gender: 'female'}
    ]
  });
});
