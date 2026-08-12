package com.devtrack.backend.security;

import com.devtrack.backend.models.DevtrackApiException;
import io.jsonwebtoken.*;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import java.util.Date;

@Component
public class JwtTokenProvider {

    @Value("${app.jwt-secret}")
    private String jwtSecretKey;

    @Value("${app.jwt-expiration-milliseconds}")
    private Long expiration;

    public String generateToken(Authentication authentication){
        String username = authentication.getName();
        Date currentDate = new Date();
        Date expireDate = new Date(new Date().getTime() + expiration);

        return Jwts.builder().
                subject(username)
                .issuedAt(currentDate)
                .expiration(expireDate)
                .signWith(key())
                .compact();
    }

    public String getUsername(String token){
        Claims claims = Jwts.parser()
                .verifyWith(key())
                .build()
                .parseSignedClaims(token)
                .getPayload();

        return claims.getSubject();
    }

    public boolean validateToken(String Token){
        try{
            Jwts.parser()
                    .verifyWith(key())
                    .build()
                    .parseSignedClaims(Token);
            return true;
        } catch (MalformedJwtException e) {
            throw new DevtrackApiException(HttpStatus.BAD_REQUEST, "Invalid Token");
        } catch (ExpiredJwtException e) {
            throw new DevtrackApiException(HttpStatus.BAD_REQUEST, "Token Expired");
        }catch (UnsupportedJwtException e) {
            throw new DevtrackApiException(HttpStatus.BAD_REQUEST, "Unsupported Token");
        }catch (IllegalArgumentException e) {
            throw new DevtrackApiException(HttpStatus.BAD_REQUEST, "Invalid Argument");
        }
    }

    private SecretKey key() {
        return Keys.hmacShaKeyFor(
                Decoders.BASE64.decode(jwtSecretKey)
        );
    }
}
