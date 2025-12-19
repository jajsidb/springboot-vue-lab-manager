const BASE_URL = 'http://localhost:8080/api';

export async function request(url: string, options: RequestInit = {}) {
  const response = await fetch(`${BASE_URL}${url}`, {
    ...options,
    headers: {
      'Content-Type': 'application/json',
      ...options.headers,
    },
  });

  if (!response.ok) {
    throw new Error(`API Error: ${response.statusText}`);
  }

  const text = await response.text();
  return text ? JSON.parse(text) : null;
}
