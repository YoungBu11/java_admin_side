// Users Tab: Edit User Save Logic
document.addEventListener('DOMContentLoaded', function() {
    let editingRow = null;
    // Attach to Edit buttons to track which row is being edited
    const editUserBtns = document.querySelectorAll('.edit-user-btn');
    const editUserModal = document.getElementById('edit-user-modal');
    const editUserName = document.getElementById('edit-user-name');
    const editUserNumber = document.getElementById('edit-user-number');
    const editUserStatus = document.getElementById('edit-user-status');
    if (editUserBtns && editUserModal) {
        editUserBtns.forEach(function(btn) {
            btn.addEventListener('click', function() {
                const row = btn.closest('tr');
                if (row) {
                    editingRow = row;
                    const cells = row.querySelectorAll('td');
                    if (cells.length >= 4) {
                        if (editUserName) editUserName.value = cells[1].textContent.trim();
                        if (editUserNumber) editUserNumber.value = cells[2].textContent.trim();
                        if (editUserStatus) editUserStatus.value = cells[3].textContent.trim();
                    }
                }
                editUserModal.style.display = 'flex';
            });
        });
    }

    // Save changes to the table row when Edit User form is submitted
    const editUserForm = document.getElementById('edit-user-form');
    if (editUserForm) {
        editUserForm.addEventListener('submit', function(e) {
            e.preventDefault();
            if (editingRow) {
                const cells = editingRow.querySelectorAll('td');
                if (cells.length >= 4) {
                    cells[1].textContent = editUserName.value.trim();
                    cells[2].textContent = editUserNumber.value.trim();
                    cells[3].textContent = editUserStatus.value;
                }
            }
            editUserModal.style.display = 'none';
            editingRow = null;
        });
    }
});
// Users Tab: Add User and Delete User Logic
document.addEventListener('DOMContentLoaded', function() {
    // Add User functionality
    const addUserForm = document.getElementById('add-user-form');
    const addUserModal = document.getElementById('add-user-modal');
    const usersTable = document.getElementById('users-table').getElementsByTagName('tbody')[0];
    if (addUserForm && usersTable) {
        addUserForm.addEventListener('submit', function(e) {
            e.preventDefault();
            const name = document.getElementById('add-user-name').value.trim();
            const number = document.getElementById('add-user-number').value.trim();
            const status = document.getElementById('add-user-status').value;
            // Generate new ID (increment last row's ID or start at 001)
            let newId = '001';
            if (usersTable.rows.length > 0) {
                const lastId = usersTable.rows[usersTable.rows.length - 1].cells[0].textContent;
                newId = (parseInt(lastId, 10) + 1).toString().padStart(3, '0');
            }
            // Create new row
            const newRow = usersTable.insertRow();
            newRow.innerHTML = `
                <td>${newId}</td>
                <td>${name}</td>
                <td>${number}</td>
                <td>${status}</td>
                <td>
                    <button class="edit-user-btn table-action-btn edit">Edit</button>
                    <button class="delete-user-btn table-action-btn delete">Delete</button>
                </td>
            `;
            // Add event listeners to new buttons
            const editBtn = newRow.querySelector('.edit-user-btn');
            const deleteBtn = newRow.querySelector('.delete-user-btn');
            if (editBtn) {
                editBtn.addEventListener('click', function() {
                    // Fill modal with row data
                    const cells = newRow.querySelectorAll('td');
                    document.getElementById('edit-user-name').value = cells[1].textContent.trim();
                    document.getElementById('edit-user-number').value = cells[2].textContent.trim();
                    document.getElementById('edit-user-status').value = cells[3].textContent.trim();
                    document.getElementById('edit-user-modal').style.display = 'flex';
                });
            }
            if (deleteBtn) {
                deleteBtn.addEventListener('click', function() {
                    usersTable.removeChild(newRow);
                });
            }
            // Close modal and reset form
            addUserModal.style.display = 'none';
            addUserForm.reset();
        });
    }

    // Delete User functionality for initial rows
    const deleteUserBtns = document.querySelectorAll('.delete-user-btn');
    deleteUserBtns.forEach(function(btn) {
        btn.addEventListener('click', function() {
            const row = btn.closest('tr');
            if (row && usersTable) {
                usersTable.removeChild(row);
            }
        });
    });
});
// Users Tab: Add/Edit User Modal Logic
// Users Tab: Add/Edit User Modal Logic
document.addEventListener('DOMContentLoaded', function() {
    // Add User Modal (Users Tab)
    const addUserBtn = document.getElementById('add-user-btn');
    const addUserModal = document.getElementById('add-user-modal');
    const closeAddUser = document.getElementById('close-add-user');
    const cancelAddUser = document.getElementById('cancel-add-user');
    if (addUserBtn && addUserModal) {
        addUserBtn.addEventListener('click', function() {
            addUserModal.style.display = 'flex';
        });
    }
    if (closeAddUser) {
        closeAddUser.addEventListener('click', function() {
            addUserModal.style.display = 'none';
        });
    }
    if (cancelAddUser) {
        cancelAddUser.addEventListener('click', function() {
            addUserModal.style.display = 'none';
        });
    }

    // Edit User Modal (Users Tab)
    const editUserBtns = document.querySelectorAll('.edit-user-btn');
    const editUserModal = document.getElementById('edit-user-modal');
    const closeEditUser = document.getElementById('close-edit-user');
    const cancelEditUser = document.getElementById('cancel-edit-user');
    const editUserName = document.getElementById('edit-user-name');
    const editUserNumber = document.getElementById('edit-user-number');
    const editUserStatus = document.getElementById('edit-user-status');
    if (editUserBtns && editUserModal) {
        editUserBtns.forEach(function(btn) {
            btn.addEventListener('click', function() {
                // Find the row (tr) for this button
                const row = btn.closest('tr');
                if (row) {
                    const cells = row.querySelectorAll('td');
                    // cells: [ID, Name, Number, Status, Actions]
                    if (cells.length >= 4) {
                        if (editUserName) editUserName.value = cells[1].textContent.trim();
                        if (editUserNumber) editUserNumber.value = cells[2].textContent.trim();
                        if (editUserStatus) editUserStatus.value = cells[3].textContent.trim();
                    }
                }
                editUserModal.style.display = 'flex';
            });
        });
    }
    if (closeEditUser) {
        closeEditUser.addEventListener('click', function() {
            editUserModal.style.display = 'none';
        });
    }
    if (cancelEditUser) {
        cancelEditUser.addEventListener('click', function() {
            editUserModal.style.display = 'none';
        });
    }
});

document.addEventListener('DOMContentLoaded', function() {
    // Password toggle functionality
    const passwordInput = document.getElementById('password');
    const passwordToggle = document.querySelector('.password-toggle');
    if (passwordInput && passwordToggle) {
        passwordToggle.addEventListener('click', function() {
            if (passwordInput.type === 'password') {
                passwordInput.type = 'text';
            } else {
                passwordInput.type = 'password';
            }
        });
    }
    // Set background image using b.jpg
    document.body.style.backgroundImage = "url('images/b.jpg')";
    document.body.style.backgroundSize = "cover";
    document.body.style.backgroundRepeat = "no-repeat";
    document.body.style.backgroundPosition = "center";

    // Login form submit handler for redirect
    const loginForm = document.getElementById('loginForm');
    if (loginForm) {
        loginForm.addEventListener('submit', function(e) {
            e.preventDefault();
            const adminId = document.getElementById('adminId').value;
            const password = document.getElementById('password').value;
            // Example credentials, adjust as needed
            if (adminId === 'admin' && password === 'admin123') {
                document.getElementById('successMessage').style.display = 'block';
                setTimeout(function() {
                    window.location.href = 'admin-dashboard.html';
                }, 1200);
            } else {
                alert('Invalid credentials.');
            }
        });
    }
});

// Additional security features simulation
document.addEventListener('keydown', function(e) {
    // Simulate caps lock warning
    if (e.getModifierState && e.getModifierState('CapsLock')) {
        console.log('Caps Lock is on - in a real app, show warning');
    }
    
    // Block common developer tools shortcuts (F12, Ctrl+Shift+I, etc.)
    if (e.key === 'F12' || 
        (e.ctrlKey && e.shiftKey && e.key === 'I') ||
        (e.ctrlKey && e.shiftKey && e.key === 'C') ||
        (e.ctrlKey && e.key === 'U')) {
        e.preventDefault();
        console.log('Developer tools access blocked for security');
    }
});

// Prevent right-click context menu for added security feel
document.addEventListener('contextmenu', function(e) {
    e.preventDefault();
});

// Session timeout simulation
let sessionTimeout;
function resetSessionTimeout() {
    clearTimeout(sessionTimeout);
    sessionTimeout = setTimeout(() => {
        console.log('Session would timeout here - redirect to login');
    }, 300000); // 5 minutes
}

// Reset timeout on user activity
document.addEventListener('mousemove', resetSessionTimeout);
document.addEventListener('keypress', resetSessionTimeout);
resetSessionTimeout();
// Quick Actions Modal Logic for Admin Dashboard
document.addEventListener('DOMContentLoaded', function() {
    // Add User Modal
    const quickAddUserBtn = document.getElementById('quick-add-user');
    const quickAddUserModal = document.getElementById('quick-add-user-modal');
    const closeQuickAddUser = document.getElementById('close-quick-add-user');
    const cancelQuickAddUser = document.getElementById('cancel-quick-add-user');
    if (quickAddUserBtn && quickAddUserModal) {
        quickAddUserBtn.addEventListener('click', function() {
            quickAddUserModal.style.display = 'flex';
        });
    }
    if (closeQuickAddUser) {
        closeQuickAddUser.addEventListener('click', function() {
            quickAddUserModal.style.display = 'none';
        });
    }
    if (cancelQuickAddUser) {
        cancelQuickAddUser.addEventListener('click', function() {
            quickAddUserModal.style.display = 'none';
        });
    }

    // Review Requests Modal
    const quickReviewBtn = document.getElementById('quick-review');
    const quickReviewModal = document.getElementById('quick-review-modal');
    const closeQuickReview = document.getElementById('close-quick-review');
    if (quickReviewBtn && quickReviewModal) {
        quickReviewBtn.addEventListener('click', function() {
            quickReviewModal.style.display = 'flex';
        });
    }
    if (closeQuickReview) {
        closeQuickReview.addEventListener('click', function() {
            quickReviewModal.style.display = 'none';
        });
    }

    // View Alerts Modal
    const quickAlertsBtn = document.getElementById('quick-alerts');
    const quickAlertsModal = document.getElementById('quick-alerts-modal');
    const closeQuickAlerts = document.getElementById('close-quick-alerts');
    if (quickAlertsBtn && quickAlertsModal) {
        quickAlertsBtn.addEventListener('click', function() {
            quickAlertsModal.style.display = 'flex';
        });
    }
    if (closeQuickAlerts) {
        closeQuickAlerts.addEventListener('click', function() {
            quickAlertsModal.style.display = 'none';
        });
    }
});