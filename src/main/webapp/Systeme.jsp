<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Gestion des Rendez-vous Médicaux</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .tab-button {
            border: none;
            padding: 10px 20px;
            margin: 0 5px;
            border-radius: 5px;
            cursor: pointer;
            transition: all 0.3s;
        }
        .tab-button.active {
            background-color: #0d6efd;
            color: white;
        }
        .tab-button:not(.active) {
            background-color: #f8f9fa;
        }
        .alert-float {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 1000;
            animation: slideIn 0.5s ease-out;
        }
        @keyframes slideIn {
            from { transform: translateX(100%); }
            to { transform: translateX(0); }
        }
    </style>
</head>
<body>
    <div class="container mt-4">
        <!-- Navigation -->
        <div class="text-center mb-4">
            <h1 class="mb-4">Gestion des Rendez-vous Médicaux</h1>
            <div class="d-flex justify-content-center gap-2">
                <button class="tab-button active" onclick="showTab('booking')">
                    Prendre RDV
                </button>
                <button class="tab-button" onclick="showTab('list')">
                    Mes Rendez-vous <span id="appointmentCount" class="badge bg-secondary">0</span>
                </button>
            </div>
        </div>

        <!-- Alerts -->
        <div id="successAlert" class="alert alert-success alert-float" style="display: none;"></div>
        <div id="errorAlert" class="alert alert-danger alert-float" style="display: none;"></div>

        <!-- Formulaire de rendez-vous -->
        <div id="bookingSection" class="card">
            <div class="card-header">
                <h5 class="mb-0">Nouveau Rendez-vous</h5>
            </div>
            <div class="card-body">
                <form id="appointmentForm">
                    <div class="mb-3">
                        <label class="form-label">Nom complet</label>
                        <input type="text" class="form-control" name="username" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Email</label>
                        <input type="email" class="form-control" name="email" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Téléphone</label>
                        <input type="tel" class="form-control" name="telephone" pattern="[0-9]{10}" required>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Date</label>
                            <input type="date" class="form-control" name="date" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Heure</label>
                            <input type="time" class="form-control" name="time" required>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Motif</label>
                        <textarea class="form-control" name="reason" rows="3" required></textarea>
                    </div>

                    <button type="submit" class="btn btn-primary w-100">
                        Confirmer le rendez-vous
                    </button>
                </form>
            </div>
        </div>

        <!-- Liste des rendez-vous -->
        <div id="listSection" class="card" style="display: none;">
            <div class="card-header">
                <h5 class="mb-0">Mes Rendez-vous</h5>
            </div>
            <div class="card-body">
                <div id="appointmentList">
                    <div class="text-center text-muted py-5" id="emptyState">
                        <p>Vous n'avez aucun rendez-vous programmé</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Configuration initiale
        let appointments = JSON.parse(localStorage.getItem('appointments') || '[]');
        const phonePattern = /^0[1-9]\d{8}$/;

        // Échappement HTML
        const escapeHtml = (text) => {
            const map = {
                '&': '&amp;',
                '<': '&lt;',
                '>': '&gt;',
                '"': '&quot;',
                "'": '&#039;'
            };
            return text.replace(/[&<>"']/g, (m) => map[m]);
        };

        // Formatage de date
        const formatDate = (dateString) => {
            const options = {
                weekday: 'long',
                year: 'numeric',
                month: 'long',
                day: 'numeric',
                hour: '2-digit',
                minute: '2-digit'
            };
            return new Date(dateString).toLocaleDateString('fr-FR', options);
        };

        // Gestion des onglets
        function showTab(tabName) {
            document.querySelectorAll('.tab-button').forEach(btn => btn.classList.remove('active'));
            event.target.classList.add('active');
            
            document.getElementById('bookingSection').style.display = 
                tabName === 'booking' ? 'block' : 'none';
            document.getElementById('listSection').style.display = 
                tabName === 'list' ? 'block' : 'none';
        }

        // Gestion du formulaire
        document.getElementById('appointmentForm').addEventListener('submit', (e) => {
            e.preventDefault();
            
            const formData = new FormData(e.target);
            const data = Object.fromEntries(formData.entries());
            
            if (!phonePattern.test(data.telephone)) {
                showAlert('error', 'Numéro de téléphone invalide');
                return;
            }

            const appointment = {
                id: Date.now(),
                ...data,
                datetime: \`\${data.date}T\${data.time}\`
            };

            appointments.push(appointment);
            localStorage.setItem('appointments', JSON.stringify(appointments));
            
            updateAppointmentList();
            showAlert('success', 'Rendez-vous enregistré !');
            e.target.reset();
        });

        // Mise à jour de la liste
        function updateAppointmentList() {
            const container = document.getElementById('appointmentList');
            const emptyState = document.getElementById('emptyState');
            const countBadge = document.getElementById('appointmentCount');
            
            countBadge.textContent = appointments.length;
            container.innerHTML = appointments.length ? '' : emptyState.outerHTML;

            appointments.sort((a, b) => new Date(b.datetime) - new Date(a.datetime));

            container.innerHTML = appointments.map(apt => \`
                <div class="card mb-3">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <h6 class="mb-1">\${escapeHtml(apt.username)}</h6>
                                <p class="text-muted mb-1">
                                    \${formatDate(apt.datetime)}
                                </p>
                                <p class="text-muted mb-1">\${escapeHtml(apt.reason)}</p>
                                <small class="text-muted">\${apt.email} - \${apt.telephone}</small>
                            </div>
                            <button class="btn btn-outline-danger btn-sm" 
                                    onclick="deleteAppointment(\${apt.id})">
                                ✕
                            </button>
                        </div>
                    </div>
                </div>
            \`).join('');
        }

        // Suppression de rendez-vous
        window.deleteAppointment = (id) => {
            appointments = appointments.filter(apt => apt.id !== id);
            localStorage.setItem('appointments', JSON.stringify(appointments));
            updateAppointmentList();
            showAlert('info', 'Rendez-vous annulé');
        };

        // Gestion des alertes
        function showAlert(type, message) {
            const alert = document.getElementById(\`\${type}Alert\`);
            alert.textContent = message;
            alert.style.display = 'block';
            setTimeout(() => alert.style.display = 'none', 3000);
        }

        // Initialisation
        updateAppointmentList();
    </script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>