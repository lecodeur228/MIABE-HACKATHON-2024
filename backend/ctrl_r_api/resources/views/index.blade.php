<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Ctl R Admin</title>
    <link rel="shortcut icon" type="image/png" href="{{asset("assets/images/logos/favicon.png")}}" />
    <link rel="stylesheet" href="{{ asset('assets/css/styles.min.css') }}" />
    
    <script src="https://kit.fontawesome.com/8f89dfc500.js" crossorigin="anonymous"></script>
</head>
<body>
    

    <div class="page-wrapper" id="main-wrapper" data-layout="vertical" data-navbarbg="skin6" data-sidebartype="full"
    data-sidebar-position="fixed" data-header-position="fixed"> 
        @include("templates.topbar")
        <div class="body-wrapper">
            @include("templates.header")
         @yield("content")
        </div>
    </div>
    <script src="{{asset("assets/libs/jquery/dist/jquery.min.js")}}" ></script>
    <script src="{{asset("assets/libs/bootstrap/dist/js/bootstrap.bundle.min.js")}}"></script>
    <script src="{{asset("assets/js/sidebarmenu.js")}}"></script>
    <script src="{{asset("assets/js/app.min.js")}}"></script>
    <script src="{{asset("assets/libs/apexcharts/dist/apexcharts.min.js")}}"></script>
    <script src="{{asset("assets/libs/simplebar/dist/simplebar.js")}}"></script>
    <script src="{{asset("assets/js/dashboard.js")}}"></script>
</body>
</html>