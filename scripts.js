
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