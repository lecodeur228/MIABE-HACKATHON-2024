<?php

namespace App\Http\Controllers\web;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;

class UsersController extends Controller
{
    public function index(Request $request)
    {
        // Récupérer le matricule de l'utilisateur à partir de la requête
        $matricule = $request->input('matricule');

        // Récupérer les utilisateurs qui ne sont pas SUPERADMIN avec leur profil associé
        $query = User::whereNotIn('role', ['SUPERADMIN'])->with("profile");

        // Filtrer les utilisateurs par matricule si spécifié dans la requête
        if ($matricule) {
            $query->where('matricule', 'LIKE', "%{$matricule}%");
        }

        // Exécuter la requête
        $nonSuperAdmins = $query->get();

        return view("pages.users", compact("nonSuperAdmins"));
    }

    public function user_controls($id)
    {
        $user = User::findOrFail($id);
    $controles = $user->controls()->get();
        return view("pages.user_controle", compact("user", "controles"));
    }

}
