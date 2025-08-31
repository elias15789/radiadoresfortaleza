<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Radiadores Fortaleza</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="estilos/styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" integrity="sha512-..." crossorigin="anonymous" referrerpolicy="no-referrer" />
</head>
<body>
    <nav class="navbar navbar-expand-lg fixed-top shadow-sm">
        <div class="container-lg"  >
          <a class="navbar-brand fw-bold text-white" href="#">Radiadores Fortaleza</a>
          <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
          </button>
          <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav mx-auto">
              <li class="nav-item">
                <a class="nav-link active" aria-current=f"page" href="#hero">Inicio</a>
              </li>
              <li class="nav-item">
                <a class="nav-link" href="#services">Productos</a>
              </li>
              <li class="nav-item">
                <a class="nav-link" href="#about">Acerca de Nosotros</a>
              </li>
              <li class="nav-item">
                <a class="nav-link" href="#projects">Marcas</a>
              </li>
              <li class="nav-item">
                <a class="nav-link" href="CatalogoServlet">Catálogo</a>
              </li>
              
              <li class="nav-item">
                <a class="nav-link d-lg-none" href="#contact">Contact</a>
              </li>
            </ul>
            <a class="btn btn-outline-dark d-none d-lg-block" href="login.jsp">Iniciar Sesión</a>
          </div>
        </div>
      </nav>
      
      <section class="hero" id="hero">
        <div class="container-lg">
          <div class="row align-items-center">
            <div class="col-sm-6">
              <h1 class="display-2 fw-bold">Radiadores Fortaleza</h1>
              <p>Expertos en radiadores de aluminio y bronce. Repuestos, distribución y atención personalizada en todo el Perú.</p>

              <button class="btn btn-outline-dark btn-lg">Contáctanos</button>
            </div>
            <div class="col-sm-6 text-center">
              <img src="img/imagenes ideas/mascotacobre.png" class="img-fluid" alt="">
            </div>
          </div>
        </div>
      </section>
      
      <section class="services bg-red" id="services">
        <div class="container">
          <h2 class="display-5 fw-bold mb-4">Productos</h2>
          <div class="row">
            <div class="col-lg col-sm-6 mt-4">
              <div class="card">
                <img src="img/imagenes ideas/Aluminio.webp" alt="">
                <div class="card-body">
                  <h5 class="card-title fw-bold">Radiadores de aluminio</h5>
                  <p class="card-text">Ligeros y resistentes, ideales para vehículos modernos gracias a su excelente capacidad de enfriamiento.</p>
                </div>
              </div>
            </div>
            <div class="col-lg col-sm-6 mt-4">
              <div class="card">
                <img src="img/imagenes ideas/cobre.png" alt="">
                <div class="card-body">
                  <h5 class="card-title fw-bold">Radiadores de Bronce</h5>
                  <p class="card-text">Fabricados para soportar altas temperaturas, ofrecen durabilidad y eficiencia en vehículos pesados y antiguos.</p>
                </div>
              </div>
            </div>
            <div class="col-lg col-sm-6 m-auto mt-4">
              <div class="card">
                <img src="img/imagenes ideas/Refrigerante.png" alt="">
                <div class="card-body">
                  <h5 class="card-title fw-bold">Refrigerantes</h5>
                  <p class="card-text">Protege tu motor contra el sobrecalentamiento y la corrosión con nuestros refrigerantes de alta calidad.</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>
      
      <section class="about  py-5" id="about">
        <div class="container">
          <h2 class="display-5 fw-bold mb-4">Acerca de Nosotros</h2>
      
          <p><strong>RADIADORES FORTALEZA</strong> es una empresa líder en fabricación, distribución, servicios de reparación y mantenimiento de intercambiadores de calor. Estamos especializados en la fabricación de paneles, radiadores, haz tubulares, aero enfriadores e intercambiadores de calor para todo tipo de vehículo y maquinaria pesada de diversos sectores empresariales.</p>
      
          <p>Con años de experiencia en el rubro, nos comprometemos a brindar productos de alta calidad y atención personalizada para satisfacer las necesidades del mercado nacional e internacional.</p>
      
        
      
          <div class="mt-4">
            <h5 class="fw-bold">¿Dónde estamos?</h5>
            <div class="ratio ratio-16x9">
              <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3870.2023944357625!2d-75.7257886!3d-14.065222600000002!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x9110e2bd4dd96b1f%3A0xa4e0d1d6abbde4e5!2sLa%20Mar%20354%2C%20Ica%2011001!5e0!3m2!1ses-419!2spe!4v1752860538657!5m2!1ses-419!2spe" 
                width="600" height="450" style="border:0;" allowfullscreen="" loading="lazy"
                referrerpolicy="no-referrer-when-downgrade">
              </iframe>
            </div>
          </div>
        </div>
      </section>
      
      <section class="projects bg-red" id="projects">
        <div class="container">
          <h2 class="display-5 fw-bold mb-4">Marcas que Trabajamos</h2>
          <div class="row">
            <div class="col-lg col-sm-6 mt-4">
              <div class="card">
                <img src="img/imagenes ideas/nissan-6-logo-png-transparent.png" class="img-fluid p-3 mx-auto d-block" style=" object-fit: contain;" >
                <div class="card-body">
                  <h5 class="card-title fw-bold">Nissan</h5>
                  <p class="card-text">Contamos con radiadores compatibles con una amplia variedad de modelos Nissan.</p>
                  <a href="CatalogoServlet" class="btn btn-outline-dark">Ver productos</a>
                </div>
              </div>
            </div>
            <div class="col-lg col-sm-6 mt-4">
              <div class="card">
                <img src="img/imagenes ideas/toyota-logo-png-transparent.png" class="img-fluid p-3 mx-auto d-block" style=" object-fit: contain;" alt="...">
                <div class="card-body">
                  <h5 class="card-title fw-bold">Toyota</h5>
                  <p class="card-text">Ofrecemos radiadores de alta calidad para vehículos Toyota, garantizando durabilidad.</p>
                  <a href="CatalogoServlet" class="btn btn-outline-dark">Ver productos</a>
                </div>
              </div>
            </div>
            <div class="col-lg col-sm-6 mt-4">
              <div class="card">
                <img src="img/imagenes ideas/nissan.png" class="card-img-top" style=" object-fit: contain;" alt="...">
                <div class="card-body">
                  <h5 class="card-title fw-bold">Hyundai</h5>
                  <p class="card-text">Disponemos de radiadores originales y alternativos para modelos Nissan antiguos y nuevos.</p>
                  <a href="CatalogoServlet" class="btn btn-outline-dark">Ver productos</a>
                </div>
              </div>
            </div>
            <div class="col-lg col-sm-6 mt-4">
              <div class="card">
                <img src="img/imagenes ideas/chevrolet-10-logo-png-transparent.png" style=" object-fit: contain;" class="card-img-top" alt="...">
                <div class="card-body">
                  <h5 class="card-title fw-bold">Chevrolet</h5>
                  <p class="card-text">Contamos con stock de radiadores para diversos modelos Chevrolet, listos para instalación.</p>
                  <a href="CatalogoServlet" class="btn btn-outline-dark">Ver productos</a>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>
      

      
      <footer class="bg-dark text-white pt-5 pb-4" id="contact">
        <div class="container text-center text-md-start">
          <div class="row">
      
            <!-- Información de la empresa -->
            <div class="col-md-4 col-lg-4 col-xl-3 mx-auto mt-3">
              <h5 class="text-uppercase mb-4 font-weight-bold text-warning">Radiadores Fortaleza</h5>
              <p>
                Especialistas en intercambiadores de calor para todo tipo de vehículos y maquinaria pesada.
              </p>
            </div>
      
            <!-- Información de contacto -->
            <div class="col-md-4 col-lg-3 col-xl-3 mx-auto mt-3">
              <h5 class="text-uppercase mb-4 font-weight-bold text-warning">Contacto</h5>
              <p><i class="fas fa-home me-3"></i> Av. la mar 354, Ica, Perú</p>
              <p><i class="fas fa-envelope me-3"></i> radiadoresfortaleza@gmail.com</p>
              <p><i class="fas fa-phone me-3"></i> +51 993 674 268</p>
              <p><i class="fas fa-clock me-3"></i> Lun - Sáb: 8:00am - 6:00pm</p>
            </div>
      
            <!-- Redes sociales -->
            <div class="col-md-4 col-lg-3 col-xl-3 mx-auto mt-3">
              <h5 class="text-uppercase mb-4 font-weight-bold text-warning">Síguenos</h5>
              <div class="social-media"></div>
              <a href="#" class="text-white me-4"><i class="fab fa-facebook fa-lg"></i></a>
              <a href="#" class="text-white me-4"><i class="fab fa-instagram fa-lg"></i></a>
              <a href="#" class="text-white me-4"><i class="fab fa-whatsapp fa-lg"></i></a>
            </div>
      
          </div>
      
          <hr class="my-4">
      
          <!-- Copyright -->
          <div class="row">
            <div class="col text-center">
              <p class="mb-0">&copy; 2025 Radiadores Fortaleza. Todos los derechos reservados.</p>
            </div>
          </div>
        </div>
      </footer>
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>