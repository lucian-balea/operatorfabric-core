import { Injectable } from '@angular/core';
import { environment } from '@env/environment';
import { HttpClient } from '@angular/common/http';
import { CrudService } from './crud-service';
import { Observable, Subject} from 'rxjs';
import { Entity } from '@ofModel/entity.model';
import { takeUntil } from 'rxjs/internal/operators/takeUntil';
import { tap } from 'rxjs/operators';

@Injectable({
  providedIn: 'root'
})
export class EntitiesService implements CrudService {
 
 readonly entitiesUrl: string;
 private _entities: Entity[];
 private ngUnsubscribe = new Subject<void>();

  /**
   * @constructor
   * @param httpClient - Angular build-in
   */
  constructor(private httpClient: HttpClient) {
    this.entitiesUrl = `${environment.urls.entities}`;
  }

  getAllEntities(): Observable<Entity[]> {
    return this.httpClient.get<Entity[]>(`${this.entitiesUrl}`);
  }



 updateEntity(entityData: Entity): Observable<Entity> {
    return this.httpClient.post<Entity>(`${this.entitiesUrl}`, entityData);
  }


  getAll(): Observable<any[]> {
    return this.getAllEntities();
  }

  update(data: any): Observable<any> {
    return this.updateEntity(data);
  }

  public loadAllEntitiesData(): Observable<any> {
    return this.getAllEntities()
      .pipe(takeUntil(this.ngUnsubscribe)
      , tap(
        (entities) => {
          if (!!entities) {
            this._entities = entities;
            console.log(new Date().toISOString(), 'List of entities loaded');
          }
        }, (error) => console.error(new Date().toISOString(), 'an error occurred', error)
      ));
  }

  public getEntities(): Entity[] {
    return this._entities;
  }

  public getEntityName(idEntity: string): string {
      const name = this._entities.find(entity => entity.id === idEntity).name;
      return (name ? name : idEntity);
    }

}
