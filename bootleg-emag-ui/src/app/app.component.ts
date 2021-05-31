import { Component, OnInit } from "@angular/core";
import { Router } from "@angular/router";
import { AuthService } from "./services/auth.service";

@Component({
  selector: "app-root",
  templateUrl: "./app.component.html",
  styleUrls: ["./app.component.scss"],
})
export class AppComponent implements OnInit {
  title = "bootleg-emag";
  isUserLoggedIn = false;

  constructor(private authService: AuthService, private router: Router) {}

  ngOnInit() {
    this.authService.user$.subscribe(() => {
      this.isUserLoggedIn = this.authService.isLoggedIn;
    });
  }

  logout() {
    this.authService.logout();
    this.router.navigateByUrl("/");
  }
}
