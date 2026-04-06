//= require jquery-1.9.1
//= require jquery_ujs
//= require jquery.ui.all
//= require gritter
//= require_self
//= require_tree .

function remove_fields(link) {
  $(link).previous("input[type=hidden]").value = "1";
  $(link).up(".fields").hide();
}

function confirmDelete() {
	var agree=confirm("Are you sure?");
	if (agree)
		return true ;
	else
		return false ;
}

function modalFunction(id){
	var host = location.protocol + '//' + location.host;
	jQuery.get(host+'/events/'+id+'?modal=true',
		'',
		function(data){
			jQuery("#modal").html(data);
			jQuery("#thisModal").modal('toggle');
		},
		'html');
}

//JS for the Start Date date/time picker 
$(function() {
  $("#event_start_at").datetimepicker(
  	{
		controlType: 'select',
		dateFormat: 'dd/mm/yy'
	});
  });

//JS for the End Date date/time picker 
$(function() {
  $("#event_end_at").datetimepicker(
  	{
		controlType: 'select',
		dateFormat: 'dd/mm/yy'
	});
});

//JS for the Report Start Date date/time picker 
$(function() {
  $("#event_report_start").datepicker();
  });

//JS for the Report End Date date/time picker 
$(function() {
  $("#event_report_end").datepicker();
});

$.extend($.gritter.options, { 
        position: 'bottom-right', // defaults to 'top-right' but can be 'bottom-left', 'bottom-right', 'top-left', 'top-right' (added in 1.7.1)
	fade_in_speed: 'medium', // how fast notifications fade in (string or int)
	fade_out_speed: 2000, // how fast the notices fade out
	time: 6000 // hang on the screen for...
});