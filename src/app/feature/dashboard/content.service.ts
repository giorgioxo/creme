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
  private apiUrl = 'http://localhost:3000/api';

  constructor(private http: HttpClient) {}

  /**
   * Get coming soon text from backend
   */
  getComingSoonText(): Observable<ComingSoonResponse> {
    return this.http.get<ComingSoonResponse>(`${this.apiUrl}/coming-soon`);
  }
}

