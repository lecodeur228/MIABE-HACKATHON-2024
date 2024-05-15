@extends("index")
@section("content")
<div class="container-fluid">
    <div class="container-fluid">
      <div class="card">
        <div class="card-body">
          <div class="row">
            <h5 class="card-title fw-semibold mb-4">Liste des alerts</h5>
           @forelse ($alerts as $alert)
           <div class="col-md-4">
           
            <div class="card">
              <div class="card-header ">
               <div class="d-flex justify-content-between">
                Matricule: {{ $alert->user->matricule }}
                <span>{{$alert->created_at->format("y/m/d h:m") }}</span>
               </div>
              </div>
              <div class="card-body">
                <h5 class="card-title">{{ $alert->motif }}</h5>
                <h6 class="card-title">Plaque : {{ $alert->plaque }}</h6>
                <p class="card-text">{{ $alert->description }}</p>
                
              </div>
            </div>
          </div>
           @empty
               
           @endforelse
           
          </div>
        </div>
      </div>
    </div>
  </div>
@endsection