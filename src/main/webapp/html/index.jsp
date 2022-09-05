<%
    (response).setHeader("Cache-Control", "max-age=0, private,no-cache,no-store,must-revalidate");
    (response).setHeader("Expires","-1");
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>IT-FORUMS</title>
    <%@include file="libs.jsp" %>
    <style>
        .filter_date_views_active,.filter_status_active,.filter_status:hover,.filter_date_views:hover{
            cursor: pointer;
            color:#007bff;
        }
    </style>
    <script type="text/javascript">
        function addToDatalist(value, elem, data) {
            $(elem).append("<option data-id=" + value.id + " value=" + value.name + "></option>");
            var index = data.selected.indexOf(value);
            data.selected.splice(index, 1);
            data.datalist.push(value);
        }
        var intelli_data = {
            tags: {
                selected: [],
                datalist: [],
                regex: false,
                onadd: function (value, elem, data) {
                    $("#tag_alert").append("<div class='tag_holder' style='margin-left:10px'><div id='curr' class='alert alert-info'><strong id='abc'>"
                        + value.name +
                        "</strong><button type='button' class='close' data-dismiss='alert' >&times;</button></div></div>");
                    var curr = $("#tag_alert").children().last();
                    curr.find(".close").on("click", _ => {
                        $(this).parentsUntil(".tag_holder").remove();
                        addToDatalist(value, elem, data);
                        getGridData();
                    });
                    getGridData();
                }
            },
            user: {
                selected: [],
                datalist: [],
                regex: false,
                onadd: function (value, elem, data) {
                    $("#user_alert").append("<div class='tag_holder' style='margin-left:10px'><div class='alert alert-info'><strong>"
                        + value.name +
                        "</strong><button type='button' class='close' data-dismiss='alert' >&times;</button></div></div>");
                    var curr = $("#user_alert").children().last();
                    curr.find(".close").on("click", _ => {
                        $(this).parentsUntil(".tag_holder").remove();
                        addToDatalist(value, elem, data);
                        getGridData();
                    });
                    getGridData();
                }
            }
        };
        $(document).ready(function(){
            var login=1;
            document.body.onunload= function(){
                localStorage.setItem("login",login);
            }
            $("#logoutbtn").click(function(){
                $.ajax({
                    url : "remove.jsp",
                    success: function(){
                        login = 0;
                        location.href="UserHomePage.jsp";
                    }
                });
            });
            $("#nav_tags").click(function(){
                $("#tag_input").focus();
            });
            $("#nav_users").click(function(){
                $("#user_input").focus();
            });
            $("#searchbtn").click(function(){
                $("#search").focus();
            });
        });
    </script>
</head>
<body id="main-area">
<%@include file="nav.jsp" %>

<section class="py-5 d-flex align-items-center" id="hero-image">
    <div class="container">
        <div class="row py-5">
            <div class="hero-overlay"></div>
            <div class="col text-center text-white ">
                <h2 class="display-4 mb-3">Learn, Share, Build</h2>
                <p class="lead mb-3">Developers from all over the world come to us to solve their biggest coding challenges. Every. Single. Day.</p>
                <button type="button" class="btn btn-c-btn">
                    Read more<i class="fas fa-arrow-right pl-1"></i>
                </button>
            </div>       <div class="container">

        </div>
        </div>
</section>
<section class="bg-dark text-white py-5" id="subscribe">
    <div class="container">
        <h3 class="display-4 text-center mb-4">Any Questions ?</h3>
        <div class="row no-gutters">
            <div class="col-md-7 mb-md-2">
                <input type="text" id="search" class="form-control" placeholder="Whats Your Programming Question ?">
            </div>
            <div class="col-md-2">
                <button type="button" class="btn btn-c-btn btn-block">Search</button>
            </div>
            <div class="ml-3 col-md-2">
                <a href="post_question.jsp?redirect=/MainData/html/UserHomePage.jsp" style="background-color:#fff;color:#333;" class="btn btn-c-btn btn-block">Add New ?</a>
            </div>
        </div>
    </div>
</section>
<!-- boxes -->
<section class="py-5 " id="c-info">
    <div class="container">
        <div class="row">
            <div class="col-lg-3 col-md-6 mb-md-3">
                <div class="card c-border">
                    <div class="card-body text-center">
                        <p class="lead">A website which helps to resolve doubts, queries related to any field by having discussions with other registered user</p>
                    </div>
                </div>
            </div>
            <div class="col-lg-3 col-md-6 mb-md-3">
                <div class="card c-border bg-c">
                    <div class="card-body text-center">
                        <p class="lead">One of the greatest talents is recognizing talent in others and giving them the forum to shine.</p>
                    </div>
                </div>
            </div>
            <div class="col-lg-3 col-md-6 mb-md-3">
                <div class="card c-border">
                    <div class="card-body text-center">
                        <p class="lead">Get opportunity to enhance their knowledge by
                            sharing their views on this platform by having discussions.</p>
                    </div>
                </div>
            </div>
            <div class="col-lg-3 col-md-6 mb-md-3">
                <div class="card c-border bg-c">
                    <div class="card-body text-center">
                        <p class="lead">One roof platform for the effective interaction,
                            effective exposure, and a right direction toward communication.</p>
                    </div>
                </div>
            </div>
        </div>

    </div>
</section>
<!-- about -->

<section id="topq" class="py-5 bg-light">
    <div class="container">
        <div class="row">
            <div class="col-md-8">
                <h3 class="display-4 pb-4 b-50  text-center">Top Questions</h3>
            </div>
            <div class="col-md-8 grid-holder">
                <!-- question card -->
            </div>
            <!-- question card ends -->
            <div class="col-md-4">
                <div id="accordion">
                    <div class="card">
                        <div class="card-header" id="date">
                            <h5 class="mb-0">
                                <button class=" w-100 btn btn-link c-btn-link " data-toggle="collapse" data-target="#date-body">
                                    Date <i class=" far fa-calendar-alt"></i>
                                </button>
                            </h5>
                        </div>
                        <div id="date-body" class="collapse show" data-parent="#accordion">
                            <div class="card-body p-0">
                                <ul class="list-group">
                                    <li class="list-group-item">
                                        <input type="radio" id="n-o" class="c-check-sidebar" name="date-opt">
                                        <label for="n-o"><i  class="far"></i><span class="filter_date_views" id="1">Newest To Oldest</span>
                                        </label>
                                    </li>
                                    <li class="list-group-item">
                                        <input type="radio" id="o-n" class="c-check-sidebar" name="date-opt">
                                        <label for="o-n"><i  class="far"></i><span class="filter_date_views" id="2">Oldest To Newest</span>
                                        </label>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div class="card">
                        <div class="card-header" id="views">
                            <h5 class="mb-0">
                                <button class=" w-100 btn btn-link c-btn-link " data-toggle="collapse" data-target="#views-body">
                                    Views <i class="fas fa-eye"></i>
                                </button>
                            </h5>
                        </div>
                        <div id="views-body" class="collapse show" data-parent="#accordion">
                            <div class="card-body p-0">
                                <ul class="list-group">
                                    <li class="list-group-item">
                                        <input type="radio" id="h-l" class="c-check-sidebar" name="date-opt">
                                        <label for="h-l"><i  class="far"></i><span class="filter_date_views" id="3">Highest To Lowest</span>
                                        </label>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div class="card">
                        <div class="card-header" id="status">
                            <h5 class="mb-0">
                                <button class=" w-100 btn btn-link c-btn-link " data-toggle="collapse" data-target="#status-body">
                                    Status <i class="far fa-lightbulb"></i>
                                </button>
                            </h5>
                        </div>
                        <div id="status-body" class="collapse show" data-parent="#accordion">
                            <div class="card-body p-0">
                                <ul class="list-group">
                                    <li class="list-group-item">
                                        <input type="radio" id="solved" class="c-check-sidebar" name="status-opt">
                                        <label for="solved"><i  class="far"></i><span class="filter_status" id="1">Solved</span>
                                        </label>
                                    </li>
                                    <li class="list-group-item">
                                        <input type="radio" id="unsolved" class="c-check-sidebar" name="status-opt">
                                        <label for="unsolved"><i  class="far"></i><span class="filter_status" id="0">Unsolved</span>
                                        </label>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div class="card">
                        <div class="card-header" id="tag_ac">
                            <h5 class="mb-0">
                                <button class=" w-100 btn btn-link c-btn-link " data-toggle="collapse" data-target="#tag_ac-body">
                                    Tags <i class="fas fa-tags"></i>
                                </button>
                            </h5>
                        </div>
                        <div id="tag_ac-body" class="collapse show" data-parent="#accordion">
                            <div class="card-body p-0">
                                <ul class="list-group">
                                    <li class="list-group-item">
                                        <input list="tags" data-url="../db/fetch.jsp" id="tag_input" class="intelli_input form-control" placeholder="Interested Tags ">
                                        <datalist id="tags">
                                        </datalist>
                                    </li>
                                </ul>
                                <div class="mt-4 justify-content-start"  style="display: flex;flex-wrap: wrap;" id="tag_alert">
                                    <!--            alert of tag-->
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="card">
                        <div class="card-header" id="user_ac">
                            <h5 class="mb-0">
                                <button class=" w-100 btn btn-link c-btn-link " data-toggle="collapse" data-target="#user_ac-body">
                                    Users <i class="fas fa-users"></i>
                                </button>
                            </h5>
                        </div>
                        <div id="user_ac-body" class="collapse show" data-parent="#accordion">
                            <div class="card-body p-0">
                                <ul class="list-group">
                                    <li class="list-group-item">
                                        <input list="user" id="user_input" data-url="../db/fetch_user.jsp" class="intelli_input form-control" placeholder="Search by Users ">
                                        <datalist id="user">
                                        </datalist>
                                    </li>
                                </ul>
                                <div class="mt-4 justify-content-start" style="display: flex;flex-wrap: wrap;" id="user_alert">
                                    <!--            alert of user-->
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>
<footer class="bg-dark text-white py-3">
    <div class="container">
        <p class="lead text-right">2022 &copy; IT-FORUM</p>
    </div>
</footer>
<template id="grid-content">
    <div class="card p-2 mb-3 ">
        <div class="row no-gutters align-items-bottom pb-3">
            <div class="d-flex flex-column align-items-center col-1 ">
                <span class="t-vote"><i class="fas fa-thumbs-up"></i> <a id="likes"> </a></span>
                <span class="t-vote"><i class="fas fa-thumbs-down"></i> <a id="dislikes"> </a></span>
            </div>
            <div class="questions col-11">
                <a class="card-title h5 pl-2 d-block qh pb-0" href="question_answer.jsp"></a>
                <p class="tags" style="display: flex;justify-content: flex-start">
                </p>
                <p class="blockquote-footer text-muted text-right text-uppercase "> <i class="far fa-clock px-1"></i><span id="time"></span> ago by
                    <a href="user_profile.jsp" class="userid"></a>
                    <i class="fas fa-eye pl-1"></i> <a id="views"  > </a>
                </p>
            </div>
        </div>
    </div>
</template>
<script src="javascript/script.js"></script>
<script src="HomePage/sort.js"></script>
</body>
</html>
