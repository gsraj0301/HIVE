# Render Static Site Deployment (Frontend)

This guide covers deploying the HIVE Flutter web UI as a **Static Site** on Render.

## Prerequisites
- GitHub repo pushed with `render.yaml` ✓ (already done)
- Flutter SDK available on Render (automatically included)
- Public GitHub repo

## Steps to Deploy on Render

1. **Go to [render.com](https://render.com)** and sign in with your GitHub account.

2. **Create a new Static Site**
   - Click **New +** → **Static Site**
   - Connect your GitHub repo `gsraj0301/HIVE`

3. **Configure the Service**
   - **Name**: `hive-frontend` (or any name you prefer)
   - **Branch**: `main`
   - **Build Command**: `flutter build web --release`
   - **Publish Directory**: `build/web`
   - **Plan**: Free tier is fine for testing

4. **Deploy**
   - Click **Create Static Site**
   - Render will automatically:
     - Clone your repo
     - Run `flutter build web --release`
     - Serve the generated files from `build/web`

5. **Update Your API Base URL** (if needed)
   - If your backend API is on Render under a different domain, update the `baseUrl` in [lib/services/api_service.dart](lib/services/api_service.dart#L5):
   ```dart
   static const String baseUrl = 'https://hive-api.onrender.com/api';  // Change to your API URL
   ```
   - Commit and push. Render will automatically rebuild.

## Accessing Your Frontend
- Once deployed, Render will provide a public URL (e.g., `https://hive-frontend.onrender.com`)
- The app will be fully functional and serve the Flutter UI (not JSON)

## Troubleshooting

**Build fails with "Flutter not found"?**
- Render's static site builder includes Flutter by default for projects with `flutter.yaml` or `pubspec.yaml`
- Ensure your `render.yaml` is in the repo root

**Blank page or 404?**
- Verify `staticPublishPath: build/web` matches the actual build output directory
- Check build logs on Render dashboard for compilation errors

**API calls fail (CORS / 404)?**
- Update `baseUrl` in [lib/services/api_service.dart](lib/services/api_service.dart#L5) to point to your backend API
- If backend is also on Render, use its public URL (e.g., `https://hive-api.onrender.com/api`)

---

**Previous Issue**: The service was returning raw JSON because the root served API endpoints. This setup separates frontend (static) from backend (API service).
