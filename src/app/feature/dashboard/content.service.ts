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
  // Use environment variable or default to localhost for development
  private apiUrl = (window as any).__API_URL__ || 'http://localhost:3000/api';

  constructor(private http: HttpClient) {}

  /**
   * Get coming soon text from backend
   */
  getComingSoonText(): Observable<ComingSoonResponse> {
    return this.http.get<ComingSoonResponse>(`${this.apiUrl}/coming-soon`);
  }
}
