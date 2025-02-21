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
        body {
            background-color: #f8f9fa;
        }
        .container {
            margin-top: 20px;
        }
        .hidden {
            display: none;
        }
    </style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container-fluid">
        <a class="navbar-brand" href="#">Gestion RDV</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link active" id="accueilLink" href="#">Accueil</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" id="mesRDVLink" href="#">Mes Rendez-vous</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" id="mesRDVMedecinLink" href="#">Rendez-vous Médecin</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<!-- Main Content -->
<div class="container">
    <div class="row">
        <div class="col-md-6 mx-auto">
            <h3 class="text-center mt-3">Prendre un Rendez-vous</h3>

            <!-- Appointment Form (Patient) -->
            <form id="appointmentForm">
                <div class="mb-3">
                    <label for="username" class="form-label">Nom d'utilisateur:</label>
                    <input type="text" class="form-control" id="username" required>
                </div>
                <div class="mb-3">
                    <label for="email" class="form-label">Email:</label>
                    <input type="email" class="form-control" id="email" required>
                </div>
                <div class="mb-3">
                    <label for="telephone" class="form-label">Téléphone:</label>
                    <input type="tel" class="form-control" id="telephone" required>
                </div>
                <div class="mb-3">
                    <label for="date" class="form-label">Date:</label>
                    <input type="date" class="form-control" id="date" required>
                </div>
                <div class="mb-3">
                    <label for="heure" class="form-label">Heure:</label>
                    <input type="time" class="form-control" id="heure" required>
                </div>
                <div class="mb-3">
                    <label for="motif" class="form-label">Motif:</label>
                    <input type="text" class="form-control" id="motif" required>
                </div>
                <button type="submit" class="btn btn-primary w-100">
                    <i class="fas fa-calendar-check"></i> Prendre Rendez-vous
                </button>
            </form>
        </div>
    </div>

    <!-- Patient's Appointment List (Hidden Initially) -->
    <div class="row mt-4 hidden" id="appointmentListContainer">
        <div class="col-md-8 mx-auto">
            <h3 class="text-center">Mes Rendez-vous</h3>
            <ul class="list-group" id="appointmentList">
                <!-- Appointments will be added here dynamically -->
            </ul>
        </div>
    </div>

    <!-- Doctor's Appointment List (Hidden Initially) -->
    <div class="row mt-4 hidden" id="doctorAppointmentListContainer">
        <div class="col-md-8 mx-auto">
            <h3 class="text-center">Rendez-vous à venir</h3>
            <ul class="list-group" id="doctorAppointmentList">
                <!-- Doctor's Appointments will be added here dynamically -->
            </ul>
        </div>
    </div>
</div>

<!-- Bootstrap JS Bundle (Includes Popper.js) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- JavaScript for Handling Appointments -->
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const appointmentForm = document.getElementById("appointmentForm");
        const appointmentListContainer = document.getElementById("appointmentListContainer");
        const appointmentList = document.getElementById("appointmentList");
        const doctorAppointmentListContainer = document.getElementById("doctorAppointmentListContainer");
        const doctorAppointmentList = document.getElementById("doctorAppointmentList");

        // Handle Patient's Appointment Submission
        appointmentForm.addEventListener("submit", function (event) {
            event.preventDefault();

            // Get input values
            const username = document.getElementById("username").value;
            const email = document.getElementById("email").value;
            const telephone = document.getElementById("telephone").value;
            const date = document.getElementById("date").value;
            const heure = document.getElementById("heure").value;
            const motif = document.getElementById("motif").value;

            if (username && email && telephone && date && heure && motif) {
                // Create new appointment item for Patient
                const listItem = document.createElement("li");
                listItem.className = "list-group-item d-flex justify-content-between align-items-center";
                listItem.innerHTML = `
                        <div>
                            <strong>${date} - ${heure}</strong>
                            <p class="mb-0">${motif}</p>
                            <small>${username} - ${email} - ${telephone}</small>
                        </div>
                        <button class="btn btn-danger btn-sm delete-btn"><i class="fas fa-trash-alt"></i></button>
                    `;

                // Add event listener to delete button (Patient)
                listItem.querySelector(".delete-btn").addEventListener("click", function () {
                    listItem.remove();
                    if (appointmentList.children.length === 0) {
                        appointmentListContainer.classList.add("hidden");
                    }
                });

                // Append appointment to the list
                appointmentList.appendChild(listItem);

                // Show appointment list container
                appointmentListContainer.classList.remove("hidden");

                // Clear form
                appointmentForm.reset();
            }
        });

        // Simulating doctor's upcoming appointments (This can be dynamic)
        const doctorAppointments = [
            { date: '2025-02-22', heure: '09:00', motif: 'Consultation générale' },
            { date: '2025-02-23', heure: '10:00', motif: 'Examen de suivi' },
        ];

        doctorAppointments.forEach(function (appointment) {
            const listItem = document.createElement("li");
            listItem.className = "list-group-item d-flex justify-content-between align-items-center";
            listItem.innerHTML = `
                    <div>
                        <strong>${appointment.date} - ${appointment.heure}</strong>
                        <p class="mb-0">${appointment.motif}</p>
                    </div>
                    <button class="btn btn-warning btn-sm reschedule-btn"><i class="fas fa-calendar-edit"></i> Reporter</button>
                    <button class="btn btn-danger btn-sm cancel-btn"><i class="fas fa-trash-alt"></i> Annuler</button>
                `;

            // Add event listener to reschedule and cancel buttons for doctor
            listItem.querySelector(".reschedule-btn").addEventListener("click", function () {
                alert("Rendez-vous reporté !");
            });
            listItem.querySelector(".cancel-btn").addEventListener("click", function () {
                listItem.remove();
                if (doctorAppointmentList.children.length === 0) {
                    doctorAppointmentListContainer.classList.add("hidden");
                }
            });

            doctorAppointmentList.appendChild(listItem);
        });

        // Show doctor's appointment list
        doctorAppointmentListContainer.classList.remove("hidden");
    });
</script>

</body>
</html>
