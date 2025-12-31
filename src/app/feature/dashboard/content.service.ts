import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

export interface ComingSoonResponse {
  text: string;
}

@Injectable({
  providedIn: 'root'
})
export class ContentService {
  private readonly apiUrl = (() => {
    const isLocalhost = ['localhost', '127.0.0.1'].includes(window.location.hostname);
    const fallback = isLocalhost
      ? 'http://localhost:3000/api'
      : `${window.location.origin}/api`;
    return (window as any).__API_URL__ || fallback;
  })();

  constructor(private http: HttpClient) {}

  /**
   * Get coming soon text from backend
   */
  getComingSoonText(): Observable<ComingSoonResponse> {
    return this.http.get<ComingSoonResponse>(`${this.apiUrl}/coming-soon`);
  }
}
