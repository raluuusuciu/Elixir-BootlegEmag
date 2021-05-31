import { HttpClient } from "@angular/common/http";
import { EventEmitter, Injectable } from "@angular/core";
import { BehaviorSubject, Observable, of, throwError } from "rxjs";
import { User } from "../models/user";
import { catchError, map } from "rxjs/operators";

const API_URL = "https://localhost:44337/api/user";

@Injectable({
	providedIn: "root",
})
export class AuthService {
	user$: BehaviorSubject<User> = new BehaviorSubject(null);

	get user(): User {
		return this.user$.value;
	}

	get isLoggedIn(): boolean {
		return this.user$.value !== null;
	}

	constructor(private http: HttpClient) { }

	// API: POST/login
	public login(user: User): Observable<User> {
		return this.http.post<User>(API_URL + "/login", user).pipe(
			map((result: User) => {
				debugger;
				this.user$.next(result);
				return result;
			}),
			catchError((err) => {
				return throwError(err);
			})
		);
	}

	// API: POST/login
	public register(user: User): Observable<User> {
		return this.http.post<User>(API_URL + "/register", user);
	}

	public logout() {
		this.user$.next(null);
	}
}
