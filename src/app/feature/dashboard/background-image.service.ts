import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

export interface BackgroundImageResponse {
  imageUrl: string | null;
  message?: string;
  createdAt?: string;
}

@Injectable({
  providedIn: 'root'
})
export class BackgroundImageService {
  private readonly apiUrl = (() => {
    const isLocalhost = ['localhost', '127.0.0.1'].includes(window.location.hostname);
    const fallback = isLocalhost
      ? 'http://localhost:3000/api'
      : `${window.location.origin}/api`;
    return (window as any).__API_URL__ || fallback;
  })();

  constructor(private http: HttpClient) {}

  /**
   * Get current background image URL
   */
  getBackgroundImage(): Observable<BackgroundImageResponse> {
    return this.http.get<BackgroundImageResponse>(`${this.apiUrl}/background-image`);
  }
}


