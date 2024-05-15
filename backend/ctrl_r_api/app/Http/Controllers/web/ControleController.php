<?php

namespace App\Http\Controllers\web;

use App\Http\Controllers\Controller;
use App\Models\Control;
use Illuminate\Http\Request;

class ControleController extends Controller
{
    public function index(Request $request)
    {
        $plaque = $request->input('plaque');
    
        $query = Control::join('users', 'controls.user_id', '=', 'users.id')
                        ->select('controls.*', 'users.matricule')
                        ->where("controls.is_deleted", "=", 0)
                        ->orderBy('controls.created_at', 'desc');
    
        if ($plaque) {
            $query->where('controls.plaque', 'LIKE', "%{$plaque}%");
        }
    
        $controles = $query->get();
    
        return view("pages.controle", compact("controles"));
    }

    public function delete_index(Request $request)
    {
        $plaque = $request->input('plaque');
    
        $query = Control::join('users', 'controls.user_id', '=', 'users.id')
                        ->select('controls.*', 'users.matricule')
                        ->where("controls.is_deleted", "=", 1)
                        ->orderBy('controls.created_at', 'desc');
    
        if ($plaque) {
            $query->where('controls.plaque', 'LIKE', "%{$plaque}%");
        }
    
        $controles = $query->get();
    
        return view("pages.delete_controle", compact("controles"));
    }
    
}
