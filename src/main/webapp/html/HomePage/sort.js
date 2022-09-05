$(document).ready(function(){
	var order_type="",status="";
	var qh="";
	function addActive(selected,elem){
		$("."+selected).removeClass(selected+"_active");
		$(elem).addClass(selected+"_active");
		setTimeout(getGridData,0)
		return $(elem).attr("id");
	}
	$(".filter_date_views").click(function (e){
		order_type = addActive("filter_date_views",this);
	});
	$(".filter_status").click(function(){
		if($(this).hasClass("filter_status_active")){
			var chkbx_id = $(this).parent().attr("for");
			setTimeout(function(){$("#"+chkbx_id).prop("checked",false);})
			$(this).removeClass("filter_status_active");
			status="";
			getGridData();
			return;
		}
		status = addActive("filter_status",this);
	});
	window.getGridData=function(){
		var tags = intelli_data.tags.selected.map(_ => _.id).join(",");
		var users = intelli_data.user.selected.map(_ => _.id).join(",");
		$.ajax({
			url:"../db/filter.jsp",
			method:"post",
			data:{
				order_type:order_type,
				status:status,
				tags:tags,
				users:users
			},
			success:function(msg){
				qh=JSON.parse(msg.trim());
				makeGrid(qh);
			}
		});
	}
	function makeGrid(data){
		$(".grid-holder").html("");
		var content = $("#grid-content").html();
		for(temp of data){
			$(".grid-holder").append(content);
			var curr = $(".grid-holder").children().last();
			curr.find(".qh").html(temp.question);
			curr.find(".qh").attr("href","question_answer.jsp?id="+temp.id);
			var time = getTime(temp.timestamp);
			curr.find("#time").html(time);
			temp.tags.split(",").map(_=> _.trim()).forEach(_ => curr.find(".tags").append(`<div class="alert alert-info" style="margin-left:10px"><strong >${_}</strong></div>`));
			curr.find(".userid").html(temp.users);
			curr.find(".userid").attr("href","user_profile.jsp?uid="+temp.userid);
			curr.find("#likes").html(temp.likes);
			curr.find("#views").html(temp.views);
			curr.find("#dislikes").html(temp.dislikes);
		}
	}
	getGridData();
	function getTime(timestamp){
		var qdate = new Date(Date.parse(timestamp));
		var currdate = new Date(Date.now());
		var diff = (currdate.getTime() - qdate.getTime());
		var days = diff /(24*60*60*1000);
		days = Math.floor(days);
		if(days>365){
			return Math.floor(days/365) + (Math.floor(days/365)<2?" year":" years");
		}
		if(days>30){
			return Math.floor(days/30) +(Math.floor(days/30)<2?" month":" months");
		}
		if(days==0){
			var diff_hours = (currdate.getTime() - qdate.getTime())/(1000*60*60);
			if(Math.floor(diff_hours)==0){
				var diff_mins = (currdate.getTime() - qdate.getTime())/(1000*60);
				if(Math.floor(diff_mins)==0){
					var diff_sec = (currdate.getTime() - qdate.getTime())/(1000);
					return Math.floor(diff_sec) +" secs";
				}
				return Math.floor(diff_mins)+ (diff_mins<2?" min":" mins");
			}
			return Math.floor(diff_hours) +(diff_hours<2? " hour":" hours");
		}
		return days+(days<2?" day":" days");
	}
});