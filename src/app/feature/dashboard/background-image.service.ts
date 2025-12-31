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
  private apiUrl = 'http://localhost:3000/api';

  constructor(private http: HttpClient) {}

  /**
   * Get current background image URL
   */
  getBackgroundImage(): Observable<BackgroundImageResponse> {
    return this.http.get<BackgroundImageResponse>(`${this.apiUrl}/background-image`);
  }
}

