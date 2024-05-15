<?php

namespace App\Http\Controllers\web;

use App\Http\Controllers\Controller;
use App\Models\Profile;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\ValidationException;

class AuthController extends Controller
{
    public function register_page(){
        return view('pages.register');
    }

    public function login_page(){
        return view('login');
    }

    public function login(Request $request)
{
    $credentials = $request->validate([
        'matricule' => 'required|string',
        'password' => 'required|string|min:8',
    ], [
        'matricule.required' => 'Matricule est requis.',
        'password.required' => 'Le mot de passe est requis.',
        'password.min' => 'Le mot de passe doit comporter au moins :min caractères.',
    ]);

    if (Auth::attempt($credentials)) {
       if (!Auth::user()->isSuperAdmin()) {
        return back()->withErrors([
            'error' => 'Acces non autorisé.',
        ]);
       } 
       $request->session()->regenerate();

       return redirect()->intended('/admin');
    }

    return back()->withErrors([
        'matricule' => 'Matricule ou mot de passe incorrect.',
    ]);
}
public function store(Request $request)
{
    try {
        // Valider les données d'entrée pour l'utilisateur
        $validator = Validator::make($request->all(), [
            'matricule' => 'required|string|unique:users',
            'email' => 'required|email|unique:users',
            'role' => 'required|string',
            'password' => 'required|string|min:6',
            'profile_name' => 'required|string',
            'profile_contact' => 'required|string',
        ], [
            'matricule.required' => 'Matricule est requis.',
            'matricule.unique' => 'Ce matricule est déjà utilisé.',
            'email.required' => 'Email est requis.',
            'email.email' => 'Email invalide.',
            'email.unique' => 'Cet email est déjà utilisé.',
            'role.required' => 'Rôle est requis.',
            'password.required' => 'Mot de passe est requis.',
            'password.min' => 'Le mot de passe doit avoir au moins :min caractères.',
            'profile_name.required' => 'Nom du profil est requis.',
            'profile_contact.required' => 'Contact du profil est requis.',
        ]);
    
        // Si la validation échoue, retourner les erreurs à la vue
        if ($validator->fails()) {
            return back()->withErrors($validator)->withInput();
        }
    
        // Créer l'utilisateur
        $user = new User();
        $user->matricule = $request->input('matricule');
        $user->email = $request->input('email');
        $user->role = $request->input('role');
        $user->password = bcrypt($request->input('password'));
        $user->save();
    
        // Créer le profil associé à l'utilisateur
        $profile = new Profile();
        $profile->user_id = $user->id;
        $profile->name = $request->input('profile_name');
        $profile->email = $request->input('email');
        $profile->contact = $request->input('profile_contact');
        $profile->save();
    
        // Répondre avec succès
        return redirect()->route('/admin/register')->with('success', 'Utilisateur et profil créés avec succès');
    } catch (\Exception $e) {
        // En cas d'erreur inattendue, retourner un message d'erreur à la vue
        return back()->with('error', 'Une erreur est survenue lors de la création de l\'utilisateur et du profil');
    }
}
public function logout()
{
    Auth::logout();
    return redirect()->route('login_page');
}
}
