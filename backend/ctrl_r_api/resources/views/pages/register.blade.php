@extends("index")
@section("content")

<div class="container-fluid mt-5">
    <div class="d-flex align-items-center justify-content-center w-100">
        <div class="row justify-content-center w-100">
          <div class="col-md-8 col-lg-6 col-xxl-8">
            <div class="card mb-0">
              <div class="card-body">
               
                <p class="text-center">Ajouter un utilisateur</p>
                <form method="POST" action="{{ route('store') }}">
                    @csrf
                
                    <div class="mb-3">
                        <label for="matricule" class="form-label">Matricule</label>
                        <input type="text" class="form-control" name="matricule" placeholder="Entrez le matricule" id="matricule" aria-describedby="matriculeHelp">
                        @error('matricule')
                            <div class="text-danger">{{ $message }}</div>
                        @enderror
                    </div>
                    <div class="mb-3">
                        <label for="profile_name" class="form-label">Nom complet</label>
                        <input type="text" class="form-control" name="profile_name" placeholder="Entrez le nom complet" id="profile_name" aria-describedby="profileNameHelp">
                        @error('profile_name')
                            <div class="text-danger">{{ $message }}</div>
                        @enderror
                    </div>
                    <div class="mb-3">
                        <label for="email" class="form-label">Email</label>
                        <input type="email" class="form-control" name="email" placeholder="Entrez l'email" id="email" aria-describedby="emailHelp">
                        @error('email')
                            <div class="text-danger">{{ $message }}</div>
                        @enderror
                    </div>
                    <div class="mb-3">
                        <label for="profile_contact" class="form-label">Contact</label>
                        <input type="tel" class="form-control" name="profile_contact" placeholder="Entrez le contact" id="profile_contact" aria-describedby="profileContactHelp">
                        @error('profile_contact')
                            <div class="text-danger">{{ $message }}</div>
                        @enderror
                    </div>
                    <div class="mb-3">
                        <label for="role" class="form-label">Rôle de l'utilisateur</label>
                        <select id="role" class="form-select" name="role" aria-describedby="roleHelp">
                            <option value="">Choisir le rôle de l'utilisateur</option>
                            <option value="OFFICIER">OFFICIER</option>
                            <option value="ADMIN">ADMIN</option>
                            <option value="SUPERADMIN">SUPERADMIN</option>
                        </select>
                        @error('role')
                            <div class="text-danger">{{ $message }}</div>
                        @enderror
                    </div>
                    <div class="mb-4">
                        <label for="password" class="form-label">Mot de passe</label>
                        <input type="password" class="form-control" placeholder="Entrez le mot de passe" id="password" name="password" aria-describedby="passwordHelp">
                        @error('password')
                            <div class="text-danger">{{ $message }}</div>
                        @enderror
                    </div>
                    <button type="submit" class="btn btn-primary w-100 py-2 fs-4 mb-4 rounded-2">Ajouter</button>
                    @if(session('success'))
                    <div class="alert alert-success">
                        {{ session('success') }}
                    </div>
                @endif
                </form>                
              </div>
            </div>
          </div>
        </div>
      </div>
</div>
@endsection