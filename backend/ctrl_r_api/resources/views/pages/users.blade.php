@extends("index")
@section("content")
<div class="container-fluid">
        <div >
            <form action="{{route("users_page")}}" class="d-flex" method="get">
                <input type="search" class="form-control" name="matricule" placeholder="Le matricule de agent...">
            <button type="submit" class="btn btn-primary mx-2" >Rechercher</button>
            </form>
        </div>
        <div class="col-lg-12 d-flex mt-3 align-items-stretch">
            <div class="card w-100 ">
              <div class="card-body p-4">
                <h5 class="card-title fw-semibold mb-4">Liste des utilisateurs </h5>
                <div class="table-responsive">
                  <table class="table text-nowrap mb-0 align-middle">
                    <thead class="text-dark fs-4">
                      <tr>
                        <th class="border-bottom-0">
                          <h6 class="fw-semibold mb-0">Matricule</h6>
                        </th>
                        <th class="border-bottom-0">
                          <h6 class="fw-semibold mb-0">Nom</h6>
                        </th>
                        <th class="border-bottom-0">
                          <h6 class="fw-semibold mb-0">Email</h6>
                        </th>
                        <th class="border-bottom-0">
                          <h6 class="fw-semibold mb-0">Télephone</h6>
                        </th>
                        <th class="border-bottom-0">
                          <h6 class="fw-semibold mb-0">Role</h6>
                        </th>
                        <th class="border-bottom-0">
                          <h6 class="fw-semibold mb-0">Contrôle</h6>
                        </th>
                        
                      </tr>
                    </thead>
                    <tbody>
                        @forelse ($nonSuperAdmins as $nonSuperAdmin )
                        <tr>
                            <td class="border-bottom-0"><h6 class="fw-semibold mb-0">{{ $nonSuperAdmin->matricule }}</h6></td>
                            <td class="border-bottom-0">
                                <h6 class="fw-semibold mb-1">{{ $nonSuperAdmin->profile->name }}</h6>                      
                            </td>
                            <td class="border-bottom-0">
                              <p class="mb-0 fw-normal">{{ $nonSuperAdmin->email }}</p>
                            </td>
                            <td class="border-bottom-0">
                              <h6 class="fw-normal mb-0 f">{{ $nonSuperAdmin->profile->contact }}</h6>
                            </td>
                            <td class="border-bottom-0">
                              <h6 class="fw-normal mb-0">{{ $nonSuperAdmin->role }}</h6>
                            </td>
                            <td class="border-bottom-0">
                               @if ($nonSuperAdmin->role != 'ADMIN')
                               <a href="{{route("user_controls", ["id" => $nonSuperAdmin->id])}}">
                                <h6 class="fw-normal mb-0 text-center"><i class="fa-solid fa-arrow-right text-primary"></i></h6>
                                  </a>
                               @endif
                            </td>
                           
                          </tr> 
                        @empty
                            <div class="alert alert-warning">Pas d'utilisateur </div>
                        @endforelse
                      
                                            
                    </tbody>
                  </table>
                </div>
              </div>
            </div>
          </div>
    </div>
@endsection