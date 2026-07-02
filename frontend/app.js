async function checkBackend() {
  const responseBox = document.getElementById("backend-response");
  responseBox.textContent = "Checking backend...";

  try {
    const response = await fetch("/api/health");

    if (!response.ok) {
      throw new Error(`Backend returned HTTP ${response.status}`);
    }

    const data = await response.json();
    responseBox.textContent = JSON.stringify(data);
  } catch (error) {
    responseBox.textContent = "Backend API call failed. Check Docker Compose logs.";
    console.error(error);
  }
}
