<?php

namespace App\Http\Controllers\web;

use App\Http\Controllers\Controller;
use App\Models\Alert;
use Illuminate\Http\Request;

class AlertController extends Controller
{
    public function index()
    {
        $alerts = Alert::with('user')->orderBy('created_at', 'desc')->get();
        return view('pages.alert',compact("alerts"));
    }
}
