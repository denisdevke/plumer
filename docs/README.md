# Plumer CLI Documentation Website

This directory contains the documentation website for Plumer CLI, built with Tailwind CSS and designed to be deployed on GitHub Pages.

## 🌐 Live Website

The documentation is available at: `https://denisdevke.github.io/plumer`

## 📁 Structure

```
docs/
├── index.html          # Main documentation page
├── js/
│   └── main.js         # Interactive JavaScript features
├── css/
│   └── custom.css      # Custom CSS styles (complementing Tailwind)
├── images/             # Images and assets (add as needed)
├── pages/              # Additional pages (for future expansion)
├── _config.yml         # Jekyll configuration for GitHub Pages
└── README.md           # This file
```

## 🚀 Features

- **Responsive Design**: Works perfectly on desktop, tablet, and mobile devices
- **Modern UI**: Built with Tailwind CSS for a clean, professional look
- **Interactive Navigation**: Smooth scrolling and active section highlighting
- **Code Blocks**: Syntax-highlighted code examples with copy functionality
- **SEO Optimized**: Proper meta tags and structured markup
- **Accessibility**: WCAG compliant with proper focus states and keyboard navigation

## 🛠 Development

### Local Development

To work on the documentation locally:

1. Clone the repository and navigate to the docs folder
2. Open `index.html` in your browser or use a local server:

   ```bash
   # Using Python
   python -m http.server 8000

   # Using Node.js
   npx http-server
   ```

3. Visit `http://localhost:8000` to see the site

### GitHub Pages Deployment

The site is configured to deploy automatically to GitHub Pages:

1. Push changes to the main branch
2. GitHub Pages will automatically build and deploy the site
3. The site will be available at `https://denisdevke.github.io/plumer`

### Customization

#### Colors

The site uses a custom color palette defined in Tailwind config:

- Primary: `#6366f1` (Indigo)
- Secondary: `#8b5cf6` (Purple)
- Accent: `#10b981` (Emerald)

#### Adding New Sections

To add new sections to the documentation:

1. Add the section to `index.html`
2. Update the navigation in the header
3. Add the section ID to the JavaScript scroll spy functionality
4. Update the mobile navigation if needed

#### Adding New Pages

For additional pages:

1. Create new HTML files in the `pages/` directory
2. Follow the same structure as `index.html`
3. Update navigation to include links to new pages

## 📱 Browser Support

The documentation supports all modern browsers:

- Chrome/Edge 80+
- Firefox 75+
- Safari 13+
- Mobile browsers (iOS Safari, Chrome Mobile)

## 🎨 Design System

The documentation follows a consistent design system:

### Typography

- Font: Inter (Google Fonts)
- Heading scales: text-4xl, text-3xl, text-xl, text-lg
- Body text: text-base, text-sm

### Spacing

- Section padding: py-12 (48px)
- Container max-width: max-w-7xl
- Grid gaps: gap-6, gap-8

### Components

- Buttons: Rounded corners (rounded-md), padding (px-4 py-2)
- Cards: Shadow (shadow-sm), rounded corners (rounded-lg)
- Code blocks: Dark theme with syntax highlighting

## 🔧 Configuration

### SEO Settings

Update `_config.yml` to modify:

- Site title and description
- Social media links
- Google Analytics ID
- Author information

### JavaScript Features

The `main.js` file includes:

- Mobile menu toggle
- Smooth scrolling navigation
- Active section highlighting
- Code block copy functionality
- Intersection Observer animations

## 📄 License

This documentation is part of the Plumer CLI project and follows the same license terms.
