// JavaScript functionality for SQL Learning Hub

document.addEventListener("DOMContentLoaded", function () {
  // Initialize syntax highlighting
  initializeSyntaxHighlighting();

  // Initialize search functionality
  initializeSearch();

  // Initialize navigation
  initializeNavigation();

  // Initialize tooltips and popovers
  initializeBootstrapComponents();
});

function initializeSyntaxHighlighting() {
  // Simple SQL syntax highlighting
  const codeBlocks = document.querySelectorAll("code.language-sql");

  codeBlocks.forEach((block) => {
    let html = block.innerHTML;

    // Highlight SQL keywords
    const keywords = [
      "SELECT",
      "FROM",
      "WHERE",
      "JOIN",
      "INNER",
      "LEFT",
      "RIGHT",
      "OUTER",
      "INSERT",
      "UPDATE",
      "DELETE",
      "CREATE",
      "ALTER",
      "DROP",
      "INDEX",
      "TABLE",
      "VIEW",
      "PROCEDURE",
      "TRIGGER",
      "FUNCTION",
      "DATABASE",
      "GROUP BY",
      "ORDER BY",
      "HAVING",
      "UNION",
      "UNION ALL",
      "AND",
      "OR",
      "NOT",
      "IN",
      "EXISTS",
      "LIKE",
      "BETWEEN",
      "COUNT",
      "SUM",
      "AVG",
      "MIN",
      "MAX",
      "DISTINCT",
      "BEGIN",
      "END",
      "IF",
      "ELSE",
      "WHILE",
      "FOR",
      "DECLARE",
      "SET",
      "EXEC",
      "EXECUTE",
      "AS",
      "ON",
      "VALUES",
    ];

    keywords.forEach((keyword) => {
      const regex = new RegExp(`\\b${keyword}\\b`, "gi");
      html = html.replace(
        regex,
        `<span class="sql-keyword">${keyword.toUpperCase()}</span>`
      );
    });

    // Highlight strings
    html = html.replace(/'([^']*)'/g, "<span class=\"sql-string\">'$1'</span>");

    // Highlight comments
    html = html.replace(/--(.*)$/gm, '<span class="sql-comment">--$1</span>');
    html = html.replace(
      /\/\*([\s\S]*?)\*\//g,
      '<span class="sql-comment">/*$1*/</span>'
    );

    block.innerHTML = html;
  });
}

function initializeSearch() {
  const searchForms = document.querySelectorAll('form[action="/search"]');

  searchForms.forEach((form) => {
    const input = form.querySelector('input[name="q"]');

    if (input) {
      // Add search suggestions
      input.addEventListener("input", function (e) {
        const value = e.target.value.toLowerCase();

        if (value.length >= 2) {
          showSearchSuggestions(value, input);
        } else {
          hideSearchSuggestions();
        }
      });

      // Handle keyboard navigation
      input.addEventListener("keydown", function (e) {
        if (e.key === "Escape") {
          hideSearchSuggestions();
        }
      });
    }
  });
}

function showSearchSuggestions(query, input) {
  const suggestions = [
    "SELECT statement",
    "JOIN operations",
    "INSERT data",
    "UPDATE records",
    "DELETE data",
    "CREATE view",
    "stored procedure",
    "trigger",
    "GROUP BY",
    "ORDER BY",
    "WHERE clause",
    "HAVING clause",
    "UNION operations",
    "subquery",
    "cursor",
    "aggregate functions",
  ];

  const filtered = suggestions.filter((s) => s.toLowerCase().includes(query));

  if (filtered.length > 0) {
    // Create or update suggestions dropdown
    let dropdown = document.getElementById("search-suggestions");
    if (!dropdown) {
      dropdown = document.createElement("div");
      dropdown.id = "search-suggestions";
      dropdown.className = "list-group position-absolute w-100";
      dropdown.style.zIndex = "1000";
      dropdown.style.top = "100%";
      dropdown.style.maxHeight = "200px";
      dropdown.style.overflowY = "auto";

      input.parentNode.style.position = "relative";
      input.parentNode.appendChild(dropdown);
    }

    dropdown.innerHTML = filtered
      .slice(0, 5)
      .map(
        (suggestion) =>
          `<a href="/search?q=${encodeURIComponent(
            suggestion
          )}" class="list-group-item list-group-item-action">
                <i class="fas fa-search text-muted me-2"></i>${suggestion}
            </a>`
      )
      .join("");

    dropdown.style.display = "block";
  }
}

function hideSearchSuggestions() {
  const dropdown = document.getElementById("search-suggestions");
  if (dropdown) {
    dropdown.style.display = "none";
  }
}

function initializeNavigation() {
  // Smooth scrolling for anchor links
  document.querySelectorAll('a[href^="#"]').forEach((anchor) => {
    anchor.addEventListener("click", function (e) {
      e.preventDefault();

      const target = document.querySelector(this.getAttribute("href"));
      if (target) {
        target.scrollIntoView({
          behavior: "smooth",
          block: "start",
        });
      }
    });
  });

  // Back to top button
  createBackToTopButton();

  // Progress indicator for topics
  updateReadingProgress();
}

function createBackToTopButton() {
  const button = document.createElement("button");
  button.innerHTML = '<i class="fas fa-arrow-up"></i>';
  button.className = "btn btn-primary position-fixed";
  button.style.bottom = "20px";
  button.style.right = "20px";
  button.style.zIndex = "1000";
  button.style.display = "none";
  button.style.borderRadius = "50%";
  button.style.width = "50px";
  button.style.height = "50px";

  button.addEventListener("click", () => {
    window.scrollTo({ top: 0, behavior: "smooth" });
  });

  document.body.appendChild(button);

  window.addEventListener("scroll", () => {
    if (window.pageYOffset > 300) {
      button.style.display = "block";
    } else {
      button.style.display = "none";
    }
  });
}

function updateReadingProgress() {
  // Create progress bar for reading
  if (document.querySelector(".topic-content")) {
    const progressBar = document.createElement("div");
    progressBar.style.position = "fixed";
    progressBar.style.top = "0";
    progressBar.style.left = "0";
    progressBar.style.width = "0%";
    progressBar.style.height = "3px";
    progressBar.style.backgroundColor = "#667eea";
    progressBar.style.zIndex = "9999";
    progressBar.style.transition = "width 0.3s ease";

    document.body.appendChild(progressBar);

    window.addEventListener("scroll", () => {
      const scrolled =
        (window.pageYOffset /
          (document.body.scrollHeight - window.innerHeight)) *
        100;
      progressBar.style.width = scrolled + "%";
    });
  }
}

function initializeBootstrapComponents() {
  // Initialize Bootstrap tooltips
  const tooltipTriggerList = [].slice.call(
    document.querySelectorAll('[data-bs-toggle="tooltip"]')
  );
  tooltipTriggerList.map(function (tooltipTriggerEl) {
    return new bootstrap.Tooltip(tooltipTriggerEl);
  });

  // Initialize Bootstrap popovers
  const popoverTriggerList = [].slice.call(
    document.querySelectorAll('[data-bs-toggle="popover"]')
  );
  popoverTriggerList.map(function (popoverTriggerEl) {
    return new bootstrap.Popover(popoverTriggerEl);
  });
}

// Utility functions
function copyCode() {
  const codeElement = event.target.closest(".code-block").querySelector("code");
  const text = codeElement.textContent;

  navigator.clipboard
    .writeText(text)
    .then(function () {
      showNotification("Kode berhasil disalin!", "success");
    })
    .catch(function () {
      // Fallback for older browsers
      const textArea = document.createElement("textarea");
      textArea.value = text;
      document.body.appendChild(textArea);
      textArea.select();
      document.execCommand("copy");
      document.body.removeChild(textArea);
      showNotification("Kode berhasil disalin!", "success");
    });
}

function toggleExplanation() {
  const explanation = document.getElementById("explanation");
  const btn = event.target.closest("button");

  if (explanation.style.display === "none") {
    explanation.style.display = "block";
    btn.innerHTML = '<i class="fas fa-eye-slash"></i> Sembunyikan Penjelasan';
    btn.classList.remove("btn-outline-success");
    btn.classList.add("btn-outline-warning");
  } else {
    explanation.style.display = "none";
    btn.innerHTML = '<i class="fas fa-lightbulb"></i> Lihat Penjelasan';
    btn.classList.remove("btn-outline-warning");
    btn.classList.add("btn-outline-success");
  }
}

function showNotification(message, type = "info") {
  // Create notification element
  const notification = document.createElement("div");
  notification.className = `alert alert-${type} alert-dismissible fade show position-fixed`;
  notification.style.top = "20px";
  notification.style.right = "20px";
  notification.style.zIndex = "9999";
  notification.style.minWidth = "300px";

  notification.innerHTML = `
        ${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    `;

  document.body.appendChild(notification);

  // Auto remove after 3 seconds
  setTimeout(() => {
    if (notification.parentNode) {
      notification.parentNode.removeChild(notification);
    }
  }, 3000);
}

// Keyboard shortcuts
document.addEventListener("keydown", function (e) {
  // Ctrl+/ for search
  if (e.ctrlKey && e.key === "/") {
    e.preventDefault();
    const searchInput = document.querySelector('input[name="q"]');
    if (searchInput) {
      searchInput.focus();
    }
  }

  // Escape to close modals or suggestions
  if (e.key === "Escape") {
    hideSearchSuggestions();
  }
});

// Print functionality
function printPage() {
  window.print();
}

// Theme toggle (if needed for future dark mode)
function toggleTheme() {
  document.body.classList.toggle("dark-theme");
  localStorage.setItem(
    "theme",
    document.body.classList.contains("dark-theme") ? "dark" : "light"
  );
}

// Load saved theme
function loadTheme() {
  const savedTheme = localStorage.getItem("theme");
  if (savedTheme === "dark") {
    document.body.classList.add("dark-theme");
  }
}

// Initialize theme on load
loadTheme();
