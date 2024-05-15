<?php

namespace App\Http\Controllers;

use App\Models\Profile;
use App\Models\User;
use Exception;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\ValidationException;

class AuthController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        try {
            // Récupérer tous les utilisateurs avec leur profil
            $usersWithProfiles = User::with('profile')->get();
    
            // Retourner la liste des utilisateurs avec leur profil
            return response()->json(['users' => $usersWithProfiles, 'status' => 'SUCCES']);
        } catch (\Exception $e) {
            // En cas d'erreur, renvoyer une réponse d'erreur
            return response()->json(['erreur' => $e->getMessage(), 'status' => 'ECHEC'], 500);
        }
    }

    /**
     * Store a newly created resource in storage.
     */
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
            ]);
        
            // Si la validation échoue, lancer une ValidationException
            if ($validator->fails()) {
                throw new ValidationException($validator);
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
            return response()->json(['message' => 'Utilisateur et profil créés avec succès','status' => 'SUCCES'], 201);
        } catch (ValidationException $e) {
            
            return response()->json(['errors' => $validator->errors(),'status' => 'ECHEC']);
        } catch (\Exception $e) {
            
            return response()->json(['message' => 'Une erreur est survenue lors de la création de l\'utilisateur et du profil','status' => 'ECHEC']);
        }
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
    
        try {
            if (Auth::attempt(['matricule' => $credentials['matricule'], 'password' => $credentials['password']])) {
                $accessToken = Auth::user()->createToken('authToken')->plainTextToken;
                return response()->json([
                    'message' => 'Connexion réussie',
                    'profile' => Auth::user()->profile,
                    'role' => Auth::user()->role,
                    'matricule' => Auth::user()->matricule,
                    'access_token' => $accessToken,
                    'status' => 'SUCCES',
                ]);
            } else {
                return response()->json([
                    'erreur' => 'Matricule ou mot de passe incorrect.',
                    'status' => 'ECHEC'
                ]);
            }
        } catch (Exception $e) {
            return response()->json([
                'erreur' => $e->getMessage(),
                'status' => 'ECHEC'
            ]);
        }
    }

    public function updateProfile(Request $request)
    {
        $user = Auth::user();

        $validatedData = $request->validate([
            'name' => 'required|string',
            'email' => 'required|email|unique:profiles,email,'.$user->profile->id,
            'contact' => 'required|string',
        ], [
            'name.required' => 'Le nom est requis.',
            'email.required' => 'L\'email est requis.',
            'email.email' => 'Le format de l\'email n\'est pas valide.',
            'email.unique' => 'Cet email est déjà utilisé par un autre utilisateur.',
            'contact.required' => 'Le contact est requis.',
        ]);

        try {
            $profile = $user->profile;
            $profile->name = $validatedData['name'];
            $profile->email = $validatedData['email'];
            $profile->contact = $validatedData['contact'];
            $profile->save();

            return response()->json(['message' => 'Profil mis à jour avec succès','status' => 'succes']);
        } catch (\Exception $e) {
            return response()->json([
                'erreur' => $e->getMessage(),
                'status' => 'ECHEC'
            ]);
        }
    }

    public function updatePassword(Request $request)
    {
        try {
            // Récupérer l'utilisateur authentifié
            $user = Auth::user();
    
            // Valider les données de la requête
            $validatedData = $request->validate([
                'current_password' => 'required|string',
                'new_password' => 'required|string|min:8',
            ], [
                'current_password.required' => 'Le mot de passe actuel est requis.',
                'new_password.required' => 'Le nouveau mot de passe est requis.',
                'new_password.min' => 'Le nouveau mot de passe doit comporter au moins :min caractères.',
                // 'new_password.confirmed' => 'La confirmation du nouveau mot de passe ne correspond pas.',
            ]);
    
            // Vérifier si le mot de passe actuel est correct
            if (!Hash::check($validatedData['current_password'], $user->password)) {
                return response()->json(['erreur' => 'Le mot de passe actuel est incorrect.'], 400);
            }
    
            // Hasher le nouveau mot de passe
            $hashedPassword = Hash::make($validatedData['new_password']);
    
            // Mettre à jour le mot de passe de l'utilisateur
            $user->password = $hashedPassword;
            $user->save();
    
            // Répondre avec succès
            return response()->json(['message' => 'Mot de passe mis à jour avec succès','status' =>'SUCCES']);
        } catch (\Exception $e) {
            // En cas d'erreur, renvoyer une réponse d'erreur
            return response()->json([
                'erreur' => $e->getMessage(),
                'status' => 'ECHEC'
            ], 500);
        }
    }
    

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        //
    }
}
