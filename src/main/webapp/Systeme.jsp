<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no">
    <title>Gestion des Rendez-vous</title>
    
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <!-- FontAwesome for Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        body { background-color: #f0f4f8; } 
        .container { margin-top: 30px; } 
        .navbar { box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); } 
        .navbar-brand { font-size: 1.5rem; font-weight: bold; } 
        .navbar-nav .nav-link { font-size: 1.1rem; padding: 15px 20px; } 
        .hidden { display: none; } 
        .appointment-card { border: 1px solid #ddd; border-radius: 8px; padding: 15px; margin-bottom: 15px; background-color: #ffffff; } 
        .appointment-card:hover { box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1); } .delete-btn { color: red; border: none; background: none; cursor: pointer; } .delete-btn:hover { text-decoration: underline; } .modal-body input { margin-bottom: 10px; }
    </style>
</head>
<body>

    <!-- Success/Error Messages -->
    <% if (request.getParameter("success") != null) { %>
        <div class="alert alert-success text-center mt-3">Rendez-vous créé avec succès!</div>
    <% } %>
    <% if (request.getParameter("error") != null) { %>
        <div class="alert alert-danger text-center mt-3">Erreur lors de la création du rendez-vous.</div>
    <% } %>

    <!-- Navbar (unchanged) -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <!-- ... (keep navbar content unchanged) ... -->
    </nav>

    <!-- Main Content -->
    <div class="container">
        <!-- Home Content -->
        <div id="accueilContent" class="row">
            <div class="col-md-6 mx-auto">
                <h3 class="text-center mt-3">Prendre un Rendez-vous</h3>

                <!-- Corrected Appointment Form -->
                <form id="appointmentForm" method="POST" action="ajouter-rdv">
                    <div class="mb-3">
                        <label for="username" class="form-label">Nom d'utilisateur:</label>
                        <input type="text" class="form-control" id="username" name="username" required>
                    </div>
                    <div class="mb-3">
                        <label for="email" class="form-label">Email:</label>
                        <input type="email" class="form-control" id="email" name="email" required>
                    </div>
                    <div class="mb-3">
                        <label for="telephone" class="form-label">Téléphone:</label>
                        <input type="tel" class="form-control" id="telephone" name="telephone" required>
                    </div>
                    <div class="mb-3">
                        <label for="date" class="form-label">Date:</label>
                        <input type="date" class="form-control" id="date" name="date" required>
                    </div>
                    <div class="mb-3">
                        <label for="heure" class="form-label">Heure:</label>
                        <input type="time" class="form-control" id="heure" name="heure" required>
                    </div>
                    <div class="mb-3">
                        <label for="motif" class="form-label">Motif:</label>
                        <input type="text" class="form-control" id="motif" name="motif" required>
                    </div>
                    <button type="submit" class="btn btn-primary w-100">
                        <i class="fas fa-calendar-check"></i> Prendre Rendez-vous
                    </button>
                </form>
            </div>
        </div>

        <!-- Appointment List (Hidden Initially) -->
        <div id="mesRDVContent" class="row mt-4 hidden">
            <div class="col-md-8 mx-auto">
                <h3 class="text-center">Mes Rendez-vous</h3>
                <div id="appointmentList">
                    <!-- Appointments will be loaded from server -->
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Updated JavaScript -->
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const appointmentForm = document.getElementById("appointmentForm");
            const appointmentListContainer = document.getElementById("mesRDVContent");
            const accueilContent = document.getElementById("accueilContent");
            const mesRDVLink = document.getElementById("mesRDVLink");
            const accueilLink = document.getElementById("accueilLink");

            // Toggle sections
            mesRDVLink.addEventListener("click", function (e) {
                e.preventDefault();
                accueilContent.classList.add("hidden");
                appointmentListContainer.classList.remove("hidden");
                loadAppointments();
            });

            accueilLink.addEventListener("click", function (e) {
                e.preventDefault();
                appointmentListContainer.classList.add("hidden");
                accueilContent.classList.remove("hidden");
            });

            // Load initial appointments
            function loadAppointments() {
                fetch('get-appointments') // Create this endpoint to return appointments
                    .then(response => response.json())
                    .then(data => {
                        const list = document.getElementById('appointmentList');
                        list.innerHTML = '';
                        data.forEach(appt => {
                            list.innerHTML += `
                                <div class="appointment-card">
                                    <div>
                                        <h5>${appt.username}</h5>
                                        <p><strong>Date:</strong> ${appt.date} - ${appt.heure}</p>
                                        <p><strong>Email:</strong> ${appt.email}</p>
                                        <p><strong>Téléphone:</strong> ${appt.telephone}</p>
                                        <p><strong>Motif:</strong> ${appt.motif}</p>
                                    </div>
                                    <button class="btn btn-danger delete-btn" data-id="${appt.id}">
                                        <i class="fas fa-trash-alt"></i> Annuler
                                    </button>
                                </div>
                            `;
                        });
                    });
            }

            // Handle form submission (no preventDefault - allow normal submission)
        });
    </script>
</body>
</html>