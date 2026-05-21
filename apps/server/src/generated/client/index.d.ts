
/**
 * Client
**/

import * as runtime from './runtime/client.js';
import $Types = runtime.Types // general types
import $Public = runtime.Types.Public
import $Utils = runtime.Types.Utils
import $Extensions = runtime.Types.Extensions
import $Result = runtime.Types.Result

export type PrismaPromise<T> = $Public.PrismaPromise<T>


/**
 * Model AppInstance
 * 
 */
export type AppInstance = $Result.DefaultSelection<Prisma.$AppInstancePayload>
/**
 * Model Photo
 * 
 */
export type Photo = $Result.DefaultSelection<Prisma.$PhotoPayload>
/**
 * Model Face
 * 
 */
export type Face = $Result.DefaultSelection<Prisma.$FacePayload>
/**
 * Model Group
 * 
 */
export type Group = $Result.DefaultSelection<Prisma.$GroupPayload>

/**
 * ##  Prisma Client ʲˢ
 *
 * Type-safe database client for TypeScript & Node.js
 * @example
 * ```
 * const prisma = new PrismaClient({
 *   adapter: new PrismaPg({ connectionString: process.env.DATABASE_URL })
 * })
 * // Fetch zero or more AppInstances
 * const appInstances = await prisma.appInstance.findMany()
 * ```
 *
 *
 * Read more in our [docs](https://pris.ly/d/client).
 */
export class PrismaClient<
  ClientOptions extends Prisma.PrismaClientOptions = Prisma.PrismaClientOptions,
  const U = 'log' extends keyof ClientOptions ? ClientOptions['log'] extends Array<Prisma.LogLevel | Prisma.LogDefinition> ? Prisma.GetEvents<ClientOptions['log']> : never : never,
  ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs
> {
  [K: symbol]: { types: Prisma.TypeMap<ExtArgs>['other'] }

    /**
   * ##  Prisma Client ʲˢ
   *
   * Type-safe database client for TypeScript & Node.js
   * @example
   * ```
   * const prisma = new PrismaClient({
   *   adapter: new PrismaPg({ connectionString: process.env.DATABASE_URL })
   * })
   * // Fetch zero or more AppInstances
   * const appInstances = await prisma.appInstance.findMany()
   * ```
   *
   *
   * Read more in our [docs](https://pris.ly/d/client).
   */

  constructor(optionsArg ?: Prisma.Subset<ClientOptions, Prisma.PrismaClientOptions>);
  $on<V extends U>(eventType: V, callback: (event: V extends 'query' ? Prisma.QueryEvent : Prisma.LogEvent) => void): PrismaClient;

  /**
   * Connect with the database
   */
  $connect(): $Utils.JsPromise<void>;

  /**
   * Disconnect from the database
   */
  $disconnect(): $Utils.JsPromise<void>;

/**
   * Executes a prepared raw query and returns the number of affected rows.
   * @example
   * ```
   * const result = await prisma.$executeRaw`UPDATE User SET cool = ${true} WHERE email = ${'user@email.com'};`
   * ```
   *
   * Read more in our [docs](https://pris.ly/d/raw-queries).
   */
  $executeRaw<T = unknown>(query: TemplateStringsArray | Prisma.Sql, ...values: any[]): Prisma.PrismaPromise<number>;

  /**
   * Executes a raw query and returns the number of affected rows.
   * Susceptible to SQL injections, see documentation.
   * @example
   * ```
   * const result = await prisma.$executeRawUnsafe('UPDATE User SET cool = $1 WHERE email = $2 ;', true, 'user@email.com')
   * ```
   *
   * Read more in our [docs](https://pris.ly/d/raw-queries).
   */
  $executeRawUnsafe<T = unknown>(query: string, ...values: any[]): Prisma.PrismaPromise<number>;

  /**
   * Performs a prepared raw query and returns the `SELECT` data.
   * @example
   * ```
   * const result = await prisma.$queryRaw`SELECT * FROM User WHERE id = ${1} OR email = ${'user@email.com'};`
   * ```
   *
   * Read more in our [docs](https://pris.ly/d/raw-queries).
   */
  $queryRaw<T = unknown>(query: TemplateStringsArray | Prisma.Sql, ...values: any[]): Prisma.PrismaPromise<T>;

  /**
   * Performs a raw query and returns the `SELECT` data.
   * Susceptible to SQL injections, see documentation.
   * @example
   * ```
   * const result = await prisma.$queryRawUnsafe('SELECT * FROM User WHERE id = $1 OR email = $2;', 1, 'user@email.com')
   * ```
   *
   * Read more in our [docs](https://pris.ly/d/raw-queries).
   */
  $queryRawUnsafe<T = unknown>(query: string, ...values: any[]): Prisma.PrismaPromise<T>;


  /**
   * Allows the running of a sequence of read/write operations that are guaranteed to either succeed or fail as a whole.
   * @example
   * ```
   * const [george, bob, alice] = await prisma.$transaction([
   *   prisma.user.create({ data: { name: 'George' } }),
   *   prisma.user.create({ data: { name: 'Bob' } }),
   *   prisma.user.create({ data: { name: 'Alice' } }),
   * ])
   * ```
   * 
   * Read more in our [docs](https://www.prisma.io/docs/orm/prisma-client/queries/transactions).
   */
  $transaction<P extends Prisma.PrismaPromise<any>[]>(arg: [...P], options?: { maxWait?: number, timeout?: number, isolationLevel?: Prisma.TransactionIsolationLevel }): $Utils.JsPromise<runtime.Types.Utils.UnwrapTuple<P>>

  $transaction<R>(fn: (prisma: Omit<PrismaClient, runtime.ITXClientDenyList>) => $Utils.JsPromise<R>, options?: { maxWait?: number, timeout?: number, isolationLevel?: Prisma.TransactionIsolationLevel }): $Utils.JsPromise<R>

  $extends: $Extensions.ExtendsHook<"extends", Prisma.TypeMapCb<ClientOptions>, ExtArgs, $Utils.Call<Prisma.TypeMapCb<ClientOptions>, {
    extArgs: ExtArgs
  }>>

      /**
   * `prisma.appInstance`: Exposes CRUD operations for the **AppInstance** model.
    * Example usage:
    * ```ts
    * // Fetch zero or more AppInstances
    * const appInstances = await prisma.appInstance.findMany()
    * ```
    */
  get appInstance(): Prisma.AppInstanceDelegate<ExtArgs, ClientOptions>;

  /**
   * `prisma.photo`: Exposes CRUD operations for the **Photo** model.
    * Example usage:
    * ```ts
    * // Fetch zero or more Photos
    * const photos = await prisma.photo.findMany()
    * ```
    */
  get photo(): Prisma.PhotoDelegate<ExtArgs, ClientOptions>;

  /**
   * `prisma.face`: Exposes CRUD operations for the **Face** model.
    * Example usage:
    * ```ts
    * // Fetch zero or more Faces
    * const faces = await prisma.face.findMany()
    * ```
    */
  get face(): Prisma.FaceDelegate<ExtArgs, ClientOptions>;

  /**
   * `prisma.group`: Exposes CRUD operations for the **Group** model.
    * Example usage:
    * ```ts
    * // Fetch zero or more Groups
    * const groups = await prisma.group.findMany()
    * ```
    */
  get group(): Prisma.GroupDelegate<ExtArgs, ClientOptions>;
}

export namespace Prisma {
  export import DMMF = runtime.DMMF

  export type PrismaPromise<T> = $Public.PrismaPromise<T>

  /**
   * Validator
   */
  export import validator = runtime.Public.validator

  /**
   * Prisma Errors
   */
  export import PrismaClientKnownRequestError = runtime.PrismaClientKnownRequestError
  export import PrismaClientUnknownRequestError = runtime.PrismaClientUnknownRequestError
  export import PrismaClientRustPanicError = runtime.PrismaClientRustPanicError
  export import PrismaClientInitializationError = runtime.PrismaClientInitializationError
  export import PrismaClientValidationError = runtime.PrismaClientValidationError

  /**
   * Re-export of sql-template-tag
   */
  export import sql = runtime.sqltag
  export import empty = runtime.empty
  export import join = runtime.join
  export import raw = runtime.raw
  export import Sql = runtime.Sql



  /**
   * Decimal.js
   */
  export import Decimal = runtime.Decimal

  export type DecimalJsLike = runtime.DecimalJsLike

  /**
  * Extensions
  */
  export import Extension = $Extensions.UserArgs
  export import getExtensionContext = runtime.Extensions.getExtensionContext
  export import Args = $Public.Args
  export import Payload = $Public.Payload
  export import Result = $Public.Result
  export import Exact = $Public.Exact

  /**
   * Prisma Client JS version: 7.8.0
   * Query Engine version: 3c6e192761c0362d496ed980de936e2f3cebcd3a
   */
  export type PrismaVersion = {
    client: string
    engine: string
  }

  export const prismaVersion: PrismaVersion

  /**
   * Utility Types
   */


  export import Bytes = runtime.Bytes
  export import JsonObject = runtime.JsonObject
  export import JsonArray = runtime.JsonArray
  export import JsonValue = runtime.JsonValue
  export import InputJsonObject = runtime.InputJsonObject
  export import InputJsonArray = runtime.InputJsonArray
  export import InputJsonValue = runtime.InputJsonValue

  /**
   * Types of the values used to represent different kinds of `null` values when working with JSON fields.
   *
   * @see https://www.prisma.io/docs/concepts/components/prisma-client/working-with-fields/working-with-json-fields#filtering-on-a-json-field
   */
  namespace NullTypes {
    /**
    * Type of `Prisma.DbNull`.
    *
    * You cannot use other instances of this class. Please use the `Prisma.DbNull` value.
    *
    * @see https://www.prisma.io/docs/concepts/components/prisma-client/working-with-fields/working-with-json-fields#filtering-on-a-json-field
    */
    class DbNull {
      private DbNull: never
      private constructor()
    }

    /**
    * Type of `Prisma.JsonNull`.
    *
    * You cannot use other instances of this class. Please use the `Prisma.JsonNull` value.
    *
    * @see https://www.prisma.io/docs/concepts/components/prisma-client/working-with-fields/working-with-json-fields#filtering-on-a-json-field
    */
    class JsonNull {
      private JsonNull: never
      private constructor()
    }

    /**
    * Type of `Prisma.AnyNull`.
    *
    * You cannot use other instances of this class. Please use the `Prisma.AnyNull` value.
    *
    * @see https://www.prisma.io/docs/concepts/components/prisma-client/working-with-fields/working-with-json-fields#filtering-on-a-json-field
    */
    class AnyNull {
      private AnyNull: never
      private constructor()
    }
  }

  /**
   * Helper for filtering JSON entries that have `null` on the database (empty on the db)
   *
   * @see https://www.prisma.io/docs/concepts/components/prisma-client/working-with-fields/working-with-json-fields#filtering-on-a-json-field
   */
  export const DbNull: NullTypes.DbNull

  /**
   * Helper for filtering JSON entries that have JSON `null` values (not empty on the db)
   *
   * @see https://www.prisma.io/docs/concepts/components/prisma-client/working-with-fields/working-with-json-fields#filtering-on-a-json-field
   */
  export const JsonNull: NullTypes.JsonNull

  /**
   * Helper for filtering JSON entries that are `Prisma.DbNull` or `Prisma.JsonNull`
   *
   * @see https://www.prisma.io/docs/concepts/components/prisma-client/working-with-fields/working-with-json-fields#filtering-on-a-json-field
   */
  export const AnyNull: NullTypes.AnyNull

  type SelectAndInclude = {
    select: any
    include: any
  }

  type SelectAndOmit = {
    select: any
    omit: any
  }

  /**
   * Get the type of the value, that the Promise holds.
   */
  export type PromiseType<T extends PromiseLike<any>> = T extends PromiseLike<infer U> ? U : T;

  /**
   * Get the return type of a function which returns a Promise.
   */
  export type PromiseReturnType<T extends (...args: any) => $Utils.JsPromise<any>> = PromiseType<ReturnType<T>>

  /**
   * From T, pick a set of properties whose keys are in the union K
   */
  type Prisma__Pick<T, K extends keyof T> = {
      [P in K]: T[P];
  };


  export type Enumerable<T> = T | Array<T>;

  export type RequiredKeys<T> = {
    [K in keyof T]-?: {} extends Prisma__Pick<T, K> ? never : K
  }[keyof T]

  export type TruthyKeys<T> = keyof {
    [K in keyof T as T[K] extends false | undefined | null ? never : K]: K
  }

  export type TrueKeys<T> = TruthyKeys<Prisma__Pick<T, RequiredKeys<T>>>

  /**
   * Subset
   * @desc From `T` pick properties that exist in `U`. Simple version of Intersection
   */
  export type Subset<T, U> = {
    [key in keyof T]: key extends keyof U ? T[key] : never;
  };

  /**
   * SelectSubset
   * @desc From `T` pick properties that exist in `U`. Simple version of Intersection.
   * Additionally, it validates, if both select and include are present. If the case, it errors.
   */
  export type SelectSubset<T, U> = {
    [key in keyof T]: key extends keyof U ? T[key] : never
  } &
    (T extends SelectAndInclude
      ? 'Please either choose `select` or `include`.'
      : T extends SelectAndOmit
        ? 'Please either choose `select` or `omit`.'
        : {})

  /**
   * Subset + Intersection
   * @desc From `T` pick properties that exist in `U` and intersect `K`
   */
  export type SubsetIntersection<T, U, K> = {
    [key in keyof T]: key extends keyof U ? T[key] : never
  } &
    K

  type Without<T, U> = { [P in Exclude<keyof T, keyof U>]?: never };

  /**
   * XOR is needed to have a real mutually exclusive union type
   * https://stackoverflow.com/questions/42123407/does-typescript-support-mutually-exclusive-types
   */
  type XOR<T, U> =
    T extends object ?
    U extends object ?
      (Without<T, U> & U) | (Without<U, T> & T)
    : U : T


  /**
   * Is T a Record?
   */
  type IsObject<T extends any> = T extends Array<any>
  ? False
  : T extends Date
  ? False
  : T extends Uint8Array
  ? False
  : T extends BigInt
  ? False
  : T extends object
  ? True
  : False


  /**
   * If it's T[], return T
   */
  export type UnEnumerate<T extends unknown> = T extends Array<infer U> ? U : T

  /**
   * From ts-toolbelt
   */

  type __Either<O extends object, K extends Key> = Omit<O, K> &
    {
      // Merge all but K
      [P in K]: Prisma__Pick<O, P & keyof O> // With K possibilities
    }[K]

  type EitherStrict<O extends object, K extends Key> = Strict<__Either<O, K>>

  type EitherLoose<O extends object, K extends Key> = ComputeRaw<__Either<O, K>>

  type _Either<
    O extends object,
    K extends Key,
    strict extends Boolean
  > = {
    1: EitherStrict<O, K>
    0: EitherLoose<O, K>
  }[strict]

  type Either<
    O extends object,
    K extends Key,
    strict extends Boolean = 1
  > = O extends unknown ? _Either<O, K, strict> : never

  export type Union = any

  type PatchUndefined<O extends object, O1 extends object> = {
    [K in keyof O]: O[K] extends undefined ? At<O1, K> : O[K]
  } & {}

  /** Helper Types for "Merge" **/
  export type IntersectOf<U extends Union> = (
    U extends unknown ? (k: U) => void : never
  ) extends (k: infer I) => void
    ? I
    : never

  export type Overwrite<O extends object, O1 extends object> = {
      [K in keyof O]: K extends keyof O1 ? O1[K] : O[K];
  } & {};

  type _Merge<U extends object> = IntersectOf<Overwrite<U, {
      [K in keyof U]-?: At<U, K>;
  }>>;

  type Key = string | number | symbol;
  type AtBasic<O extends object, K extends Key> = K extends keyof O ? O[K] : never;
  type AtStrict<O extends object, K extends Key> = O[K & keyof O];
  type AtLoose<O extends object, K extends Key> = O extends unknown ? AtStrict<O, K> : never;
  export type At<O extends object, K extends Key, strict extends Boolean = 1> = {
      1: AtStrict<O, K>;
      0: AtLoose<O, K>;
  }[strict];

  export type ComputeRaw<A extends any> = A extends Function ? A : {
    [K in keyof A]: A[K];
  } & {};

  export type OptionalFlat<O> = {
    [K in keyof O]?: O[K];
  } & {};

  type _Record<K extends keyof any, T> = {
    [P in K]: T;
  };

  // cause typescript not to expand types and preserve names
  type NoExpand<T> = T extends unknown ? T : never;

  // this type assumes the passed object is entirely optional
  type AtLeast<O extends object, K extends string> = NoExpand<
    O extends unknown
    ? | (K extends keyof O ? { [P in K]: O[P] } & O : O)
      | {[P in keyof O as P extends K ? P : never]-?: O[P]} & O
    : never>;

  type _Strict<U, _U = U> = U extends unknown ? U & OptionalFlat<_Record<Exclude<Keys<_U>, keyof U>, never>> : never;

  export type Strict<U extends object> = ComputeRaw<_Strict<U>>;
  /** End Helper Types for "Merge" **/

  export type Merge<U extends object> = ComputeRaw<_Merge<Strict<U>>>;

  /**
  A [[Boolean]]
  */
  export type Boolean = True | False

  // /**
  // 1
  // */
  export type True = 1

  /**
  0
  */
  export type False = 0

  export type Not<B extends Boolean> = {
    0: 1
    1: 0
  }[B]

  export type Extends<A1 extends any, A2 extends any> = [A1] extends [never]
    ? 0 // anything `never` is false
    : A1 extends A2
    ? 1
    : 0

  export type Has<U extends Union, U1 extends Union> = Not<
    Extends<Exclude<U1, U>, U1>
  >

  export type Or<B1 extends Boolean, B2 extends Boolean> = {
    0: {
      0: 0
      1: 1
    }
    1: {
      0: 1
      1: 1
    }
  }[B1][B2]

  export type Keys<U extends Union> = U extends unknown ? keyof U : never

  type Cast<A, B> = A extends B ? A : B;

  export const type: unique symbol;



  /**
   * Used by group by
   */

  export type GetScalarType<T, O> = O extends object ? {
    [P in keyof T]: P extends keyof O
      ? O[P]
      : never
  } : never

  type FieldPaths<
    T,
    U = Omit<T, '_avg' | '_sum' | '_count' | '_min' | '_max'>
  > = IsObject<T> extends True ? U : T

  type GetHavingFields<T> = {
    [K in keyof T]: Or<
      Or<Extends<'OR', K>, Extends<'AND', K>>,
      Extends<'NOT', K>
    > extends True
      ? // infer is only needed to not hit TS limit
        // based on the brilliant idea of Pierre-Antoine Mills
        // https://github.com/microsoft/TypeScript/issues/30188#issuecomment-478938437
        T[K] extends infer TK
        ? GetHavingFields<UnEnumerate<TK> extends object ? Merge<UnEnumerate<TK>> : never>
        : never
      : {} extends FieldPaths<T[K]>
      ? never
      : K
  }[keyof T]

  /**
   * Convert tuple to union
   */
  type _TupleToUnion<T> = T extends (infer E)[] ? E : never
  type TupleToUnion<K extends readonly any[]> = _TupleToUnion<K>
  type MaybeTupleToUnion<T> = T extends any[] ? TupleToUnion<T> : T

  /**
   * Like `Pick`, but additionally can also accept an array of keys
   */
  type PickEnumerable<T, K extends Enumerable<keyof T> | keyof T> = Prisma__Pick<T, MaybeTupleToUnion<K>>

  /**
   * Exclude all keys with underscores
   */
  type ExcludeUnderscoreKeys<T extends string> = T extends `_${string}` ? never : T


  export type FieldRef<Model, FieldType> = runtime.FieldRef<Model, FieldType>

  type FieldRefInputType<Model, FieldType> = Model extends never ? never : FieldRef<Model, FieldType>


  export const ModelName: {
    AppInstance: 'AppInstance',
    Photo: 'Photo',
    Face: 'Face',
    Group: 'Group'
  };

  export type ModelName = (typeof ModelName)[keyof typeof ModelName]



  interface TypeMapCb<ClientOptions = {}> extends $Utils.Fn<{extArgs: $Extensions.InternalArgs }, $Utils.Record<string, any>> {
    returns: Prisma.TypeMap<this['params']['extArgs'], ClientOptions extends { omit: infer OmitOptions } ? OmitOptions : {}>
  }

  export type TypeMap<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs, GlobalOmitOptions = {}> = {
    globalOmitOptions: {
      omit: GlobalOmitOptions
    }
    meta: {
      modelProps: "appInstance" | "photo" | "face" | "group"
      txIsolationLevel: Prisma.TransactionIsolationLevel
    }
    model: {
      AppInstance: {
        payload: Prisma.$AppInstancePayload<ExtArgs>
        fields: Prisma.AppInstanceFieldRefs
        operations: {
          findUnique: {
            args: Prisma.AppInstanceFindUniqueArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$AppInstancePayload> | null
          }
          findUniqueOrThrow: {
            args: Prisma.AppInstanceFindUniqueOrThrowArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$AppInstancePayload>
          }
          findFirst: {
            args: Prisma.AppInstanceFindFirstArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$AppInstancePayload> | null
          }
          findFirstOrThrow: {
            args: Prisma.AppInstanceFindFirstOrThrowArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$AppInstancePayload>
          }
          findMany: {
            args: Prisma.AppInstanceFindManyArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$AppInstancePayload>[]
          }
          create: {
            args: Prisma.AppInstanceCreateArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$AppInstancePayload>
          }
          createMany: {
            args: Prisma.AppInstanceCreateManyArgs<ExtArgs>
            result: BatchPayload
          }
          delete: {
            args: Prisma.AppInstanceDeleteArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$AppInstancePayload>
          }
          update: {
            args: Prisma.AppInstanceUpdateArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$AppInstancePayload>
          }
          deleteMany: {
            args: Prisma.AppInstanceDeleteManyArgs<ExtArgs>
            result: BatchPayload
          }
          updateMany: {
            args: Prisma.AppInstanceUpdateManyArgs<ExtArgs>
            result: BatchPayload
          }
          upsert: {
            args: Prisma.AppInstanceUpsertArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$AppInstancePayload>
          }
          aggregate: {
            args: Prisma.AppInstanceAggregateArgs<ExtArgs>
            result: $Utils.Optional<AggregateAppInstance>
          }
          groupBy: {
            args: Prisma.AppInstanceGroupByArgs<ExtArgs>
            result: $Utils.Optional<AppInstanceGroupByOutputType>[]
          }
          count: {
            args: Prisma.AppInstanceCountArgs<ExtArgs>
            result: $Utils.Optional<AppInstanceCountAggregateOutputType> | number
          }
        }
      }
      Photo: {
        payload: Prisma.$PhotoPayload<ExtArgs>
        fields: Prisma.PhotoFieldRefs
        operations: {
          findUnique: {
            args: Prisma.PhotoFindUniqueArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$PhotoPayload> | null
          }
          findUniqueOrThrow: {
            args: Prisma.PhotoFindUniqueOrThrowArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$PhotoPayload>
          }
          findFirst: {
            args: Prisma.PhotoFindFirstArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$PhotoPayload> | null
          }
          findFirstOrThrow: {
            args: Prisma.PhotoFindFirstOrThrowArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$PhotoPayload>
          }
          findMany: {
            args: Prisma.PhotoFindManyArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$PhotoPayload>[]
          }
          create: {
            args: Prisma.PhotoCreateArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$PhotoPayload>
          }
          createMany: {
            args: Prisma.PhotoCreateManyArgs<ExtArgs>
            result: BatchPayload
          }
          delete: {
            args: Prisma.PhotoDeleteArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$PhotoPayload>
          }
          update: {
            args: Prisma.PhotoUpdateArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$PhotoPayload>
          }
          deleteMany: {
            args: Prisma.PhotoDeleteManyArgs<ExtArgs>
            result: BatchPayload
          }
          updateMany: {
            args: Prisma.PhotoUpdateManyArgs<ExtArgs>
            result: BatchPayload
          }
          upsert: {
            args: Prisma.PhotoUpsertArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$PhotoPayload>
          }
          aggregate: {
            args: Prisma.PhotoAggregateArgs<ExtArgs>
            result: $Utils.Optional<AggregatePhoto>
          }
          groupBy: {
            args: Prisma.PhotoGroupByArgs<ExtArgs>
            result: $Utils.Optional<PhotoGroupByOutputType>[]
          }
          count: {
            args: Prisma.PhotoCountArgs<ExtArgs>
            result: $Utils.Optional<PhotoCountAggregateOutputType> | number
          }
        }
      }
      Face: {
        payload: Prisma.$FacePayload<ExtArgs>
        fields: Prisma.FaceFieldRefs
        operations: {
          findUnique: {
            args: Prisma.FaceFindUniqueArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$FacePayload> | null
          }
          findUniqueOrThrow: {
            args: Prisma.FaceFindUniqueOrThrowArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$FacePayload>
          }
          findFirst: {
            args: Prisma.FaceFindFirstArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$FacePayload> | null
          }
          findFirstOrThrow: {
            args: Prisma.FaceFindFirstOrThrowArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$FacePayload>
          }
          findMany: {
            args: Prisma.FaceFindManyArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$FacePayload>[]
          }
          create: {
            args: Prisma.FaceCreateArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$FacePayload>
          }
          createMany: {
            args: Prisma.FaceCreateManyArgs<ExtArgs>
            result: BatchPayload
          }
          delete: {
            args: Prisma.FaceDeleteArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$FacePayload>
          }
          update: {
            args: Prisma.FaceUpdateArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$FacePayload>
          }
          deleteMany: {
            args: Prisma.FaceDeleteManyArgs<ExtArgs>
            result: BatchPayload
          }
          updateMany: {
            args: Prisma.FaceUpdateManyArgs<ExtArgs>
            result: BatchPayload
          }
          upsert: {
            args: Prisma.FaceUpsertArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$FacePayload>
          }
          aggregate: {
            args: Prisma.FaceAggregateArgs<ExtArgs>
            result: $Utils.Optional<AggregateFace>
          }
          groupBy: {
            args: Prisma.FaceGroupByArgs<ExtArgs>
            result: $Utils.Optional<FaceGroupByOutputType>[]
          }
          count: {
            args: Prisma.FaceCountArgs<ExtArgs>
            result: $Utils.Optional<FaceCountAggregateOutputType> | number
          }
        }
      }
      Group: {
        payload: Prisma.$GroupPayload<ExtArgs>
        fields: Prisma.GroupFieldRefs
        operations: {
          findUnique: {
            args: Prisma.GroupFindUniqueArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$GroupPayload> | null
          }
          findUniqueOrThrow: {
            args: Prisma.GroupFindUniqueOrThrowArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$GroupPayload>
          }
          findFirst: {
            args: Prisma.GroupFindFirstArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$GroupPayload> | null
          }
          findFirstOrThrow: {
            args: Prisma.GroupFindFirstOrThrowArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$GroupPayload>
          }
          findMany: {
            args: Prisma.GroupFindManyArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$GroupPayload>[]
          }
          create: {
            args: Prisma.GroupCreateArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$GroupPayload>
          }
          createMany: {
            args: Prisma.GroupCreateManyArgs<ExtArgs>
            result: BatchPayload
          }
          delete: {
            args: Prisma.GroupDeleteArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$GroupPayload>
          }
          update: {
            args: Prisma.GroupUpdateArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$GroupPayload>
          }
          deleteMany: {
            args: Prisma.GroupDeleteManyArgs<ExtArgs>
            result: BatchPayload
          }
          updateMany: {
            args: Prisma.GroupUpdateManyArgs<ExtArgs>
            result: BatchPayload
          }
          upsert: {
            args: Prisma.GroupUpsertArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$GroupPayload>
          }
          aggregate: {
            args: Prisma.GroupAggregateArgs<ExtArgs>
            result: $Utils.Optional<AggregateGroup>
          }
          groupBy: {
            args: Prisma.GroupGroupByArgs<ExtArgs>
            result: $Utils.Optional<GroupGroupByOutputType>[]
          }
          count: {
            args: Prisma.GroupCountArgs<ExtArgs>
            result: $Utils.Optional<GroupCountAggregateOutputType> | number
          }
        }
      }
    }
  } & {
    other: {
      payload: any
      operations: {
        $executeRaw: {
          args: [query: TemplateStringsArray | Prisma.Sql, ...values: any[]],
          result: any
        }
        $executeRawUnsafe: {
          args: [query: string, ...values: any[]],
          result: any
        }
        $queryRaw: {
          args: [query: TemplateStringsArray | Prisma.Sql, ...values: any[]],
          result: any
        }
        $queryRawUnsafe: {
          args: [query: string, ...values: any[]],
          result: any
        }
      }
    }
  }
  export const defineExtension: $Extensions.ExtendsHook<"define", Prisma.TypeMapCb, $Extensions.DefaultArgs>
  export type DefaultPrismaClient = PrismaClient
  export type ErrorFormat = 'pretty' | 'colorless' | 'minimal'
  export interface PrismaClientOptions {
    /**
     * @default "colorless"
     */
    errorFormat?: ErrorFormat
    /**
     * @example
     * ```
     * // Shorthand for `emit: 'stdout'`
     * log: ['query', 'info', 'warn', 'error']
     * 
     * // Emit as events only
     * log: [
     *   { emit: 'event', level: 'query' },
     *   { emit: 'event', level: 'info' },
     *   { emit: 'event', level: 'warn' }
     *   { emit: 'event', level: 'error' }
     * ]
     * 
     * / Emit as events and log to stdout
     * og: [
     *  { emit: 'stdout', level: 'query' },
     *  { emit: 'stdout', level: 'info' },
     *  { emit: 'stdout', level: 'warn' }
     *  { emit: 'stdout', level: 'error' }
     * 
     * ```
     * Read more in our [docs](https://pris.ly/d/logging).
     */
    log?: (LogLevel | LogDefinition)[]
    /**
     * The default values for transactionOptions
     * maxWait ?= 2000
     * timeout ?= 5000
     */
    transactionOptions?: {
      maxWait?: number
      timeout?: number
      isolationLevel?: Prisma.TransactionIsolationLevel
    }
    /**
     * Instance of a Driver Adapter, e.g., like one provided by `@prisma/adapter-planetscale`
     */
    adapter?: runtime.SqlDriverAdapterFactory
    /**
     * Prisma Accelerate URL allowing the client to connect through Accelerate instead of a direct database.
     */
    accelerateUrl?: string
    /**
     * Global configuration for omitting model fields by default.
     * 
     * @example
     * ```
     * const prisma = new PrismaClient({
     *   omit: {
     *     user: {
     *       password: true
     *     }
     *   }
     * })
     * ```
     */
    omit?: Prisma.GlobalOmitConfig
    /**
     * SQL commenter plugins that add metadata to SQL queries as comments.
     * Comments follow the sqlcommenter format: https://google.github.io/sqlcommenter/
     * 
     * @example
     * ```
     * const prisma = new PrismaClient({
     *   adapter,
     *   comments: [
     *     traceContext(),
     *     queryInsights(),
     *   ],
     * })
     * ```
     */
    comments?: runtime.SqlCommenterPlugin[]
  }
  export type GlobalOmitConfig = {
    appInstance?: AppInstanceOmit
    photo?: PhotoOmit
    face?: FaceOmit
    group?: GroupOmit
  }

  /* Types for Logging */
  export type LogLevel = 'info' | 'query' | 'warn' | 'error'
  export type LogDefinition = {
    level: LogLevel
    emit: 'stdout' | 'event'
  }

  export type CheckIsLogLevel<T> = T extends LogLevel ? T : never;

  export type GetLogType<T> = CheckIsLogLevel<
    T extends LogDefinition ? T['level'] : T
  >;

  export type GetEvents<T extends any[]> = T extends Array<LogLevel | LogDefinition>
    ? GetLogType<T[number]>
    : never;

  export type QueryEvent = {
    timestamp: Date
    query: string
    params: string
    duration: number
    target: string
  }

  export type LogEvent = {
    timestamp: Date
    message: string
    target: string
  }
  /* End Types for Logging */


  export type PrismaAction =
    | 'findUnique'
    | 'findUniqueOrThrow'
    | 'findMany'
    | 'findFirst'
    | 'findFirstOrThrow'
    | 'create'
    | 'createMany'
    | 'createManyAndReturn'
    | 'update'
    | 'updateMany'
    | 'updateManyAndReturn'
    | 'upsert'
    | 'delete'
    | 'deleteMany'
    | 'executeRaw'
    | 'queryRaw'
    | 'aggregate'
    | 'count'
    | 'runCommandRaw'
    | 'findRaw'
    | 'groupBy'

  // tested in getLogLevel.test.ts
  export function getLogLevel(log: Array<LogLevel | LogDefinition>): LogLevel | undefined;

  /**
   * `PrismaClient` proxy available in interactive transactions.
   */
  export type TransactionClient = Omit<Prisma.DefaultPrismaClient, runtime.ITXClientDenyList>

  export type Datasource = {
    url?: string
  }

  /**
   * Count Types
   */


  /**
   * Count Type AppInstanceCountOutputType
   */

  export type AppInstanceCountOutputType = {
    photos: number
    groups: number
  }

  export type AppInstanceCountOutputTypeSelect<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    photos?: boolean | AppInstanceCountOutputTypeCountPhotosArgs
    groups?: boolean | AppInstanceCountOutputTypeCountGroupsArgs
  }

  // Custom InputTypes
  /**
   * AppInstanceCountOutputType without action
   */
  export type AppInstanceCountOutputTypeDefaultArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the AppInstanceCountOutputType
     */
    select?: AppInstanceCountOutputTypeSelect<ExtArgs> | null
  }

  /**
   * AppInstanceCountOutputType without action
   */
  export type AppInstanceCountOutputTypeCountPhotosArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    where?: PhotoWhereInput
  }

  /**
   * AppInstanceCountOutputType without action
   */
  export type AppInstanceCountOutputTypeCountGroupsArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    where?: GroupWhereInput
  }


  /**
   * Count Type PhotoCountOutputType
   */

  export type PhotoCountOutputType = {
    faces: number
  }

  export type PhotoCountOutputTypeSelect<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    faces?: boolean | PhotoCountOutputTypeCountFacesArgs
  }

  // Custom InputTypes
  /**
   * PhotoCountOutputType without action
   */
  export type PhotoCountOutputTypeDefaultArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the PhotoCountOutputType
     */
    select?: PhotoCountOutputTypeSelect<ExtArgs> | null
  }

  /**
   * PhotoCountOutputType without action
   */
  export type PhotoCountOutputTypeCountFacesArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    where?: FaceWhereInput
  }


  /**
   * Count Type GroupCountOutputType
   */

  export type GroupCountOutputType = {
    faces: number
  }

  export type GroupCountOutputTypeSelect<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    faces?: boolean | GroupCountOutputTypeCountFacesArgs
  }

  // Custom InputTypes
  /**
   * GroupCountOutputType without action
   */
  export type GroupCountOutputTypeDefaultArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the GroupCountOutputType
     */
    select?: GroupCountOutputTypeSelect<ExtArgs> | null
  }

  /**
   * GroupCountOutputType without action
   */
  export type GroupCountOutputTypeCountFacesArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    where?: FaceWhereInput
  }


  /**
   * Models
   */

  /**
   * Model AppInstance
   */

  export type AggregateAppInstance = {
    _count: AppInstanceCountAggregateOutputType | null
    _avg: AppInstanceAvgAggregateOutputType | null
    _sum: AppInstanceSumAggregateOutputType | null
    _min: AppInstanceMinAggregateOutputType | null
    _max: AppInstanceMaxAggregateOutputType | null
  }

  export type AppInstanceAvgAggregateOutputType = {
    id: number | null
  }

  export type AppInstanceSumAggregateOutputType = {
    id: number | null
  }

  export type AppInstanceMinAggregateOutputType = {
    id: number | null
    createdAt: Date | null
  }

  export type AppInstanceMaxAggregateOutputType = {
    id: number | null
    createdAt: Date | null
  }

  export type AppInstanceCountAggregateOutputType = {
    id: number
    createdAt: number
    _all: number
  }


  export type AppInstanceAvgAggregateInputType = {
    id?: true
  }

  export type AppInstanceSumAggregateInputType = {
    id?: true
  }

  export type AppInstanceMinAggregateInputType = {
    id?: true
    createdAt?: true
  }

  export type AppInstanceMaxAggregateInputType = {
    id?: true
    createdAt?: true
  }

  export type AppInstanceCountAggregateInputType = {
    id?: true
    createdAt?: true
    _all?: true
  }

  export type AppInstanceAggregateArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Filter which AppInstance to aggregate.
     */
    where?: AppInstanceWhereInput
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/sorting Sorting Docs}
     * 
     * Determine the order of AppInstances to fetch.
     */
    orderBy?: AppInstanceOrderByWithRelationInput | AppInstanceOrderByWithRelationInput[]
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination#cursor-based-pagination Cursor Docs}
     * 
     * Sets the start position
     */
    cursor?: AppInstanceWhereUniqueInput
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination Pagination Docs}
     * 
     * Take `±n` AppInstances from the position of the cursor.
     */
    take?: number
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination Pagination Docs}
     * 
     * Skip the first `n` AppInstances.
     */
    skip?: number
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/aggregations Aggregation Docs}
     * 
     * Count returned AppInstances
    **/
    _count?: true | AppInstanceCountAggregateInputType
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/aggregations Aggregation Docs}
     * 
     * Select which fields to average
    **/
    _avg?: AppInstanceAvgAggregateInputType
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/aggregations Aggregation Docs}
     * 
     * Select which fields to sum
    **/
    _sum?: AppInstanceSumAggregateInputType
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/aggregations Aggregation Docs}
     * 
     * Select which fields to find the minimum value
    **/
    _min?: AppInstanceMinAggregateInputType
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/aggregations Aggregation Docs}
     * 
     * Select which fields to find the maximum value
    **/
    _max?: AppInstanceMaxAggregateInputType
  }

  export type GetAppInstanceAggregateType<T extends AppInstanceAggregateArgs> = {
        [P in keyof T & keyof AggregateAppInstance]: P extends '_count' | 'count'
      ? T[P] extends true
        ? number
        : GetScalarType<T[P], AggregateAppInstance[P]>
      : GetScalarType<T[P], AggregateAppInstance[P]>
  }




  export type AppInstanceGroupByArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    where?: AppInstanceWhereInput
    orderBy?: AppInstanceOrderByWithAggregationInput | AppInstanceOrderByWithAggregationInput[]
    by: AppInstanceScalarFieldEnum[] | AppInstanceScalarFieldEnum
    having?: AppInstanceScalarWhereWithAggregatesInput
    take?: number
    skip?: number
    _count?: AppInstanceCountAggregateInputType | true
    _avg?: AppInstanceAvgAggregateInputType
    _sum?: AppInstanceSumAggregateInputType
    _min?: AppInstanceMinAggregateInputType
    _max?: AppInstanceMaxAggregateInputType
  }

  export type AppInstanceGroupByOutputType = {
    id: number
    createdAt: Date
    _count: AppInstanceCountAggregateOutputType | null
    _avg: AppInstanceAvgAggregateOutputType | null
    _sum: AppInstanceSumAggregateOutputType | null
    _min: AppInstanceMinAggregateOutputType | null
    _max: AppInstanceMaxAggregateOutputType | null
  }

  type GetAppInstanceGroupByPayload<T extends AppInstanceGroupByArgs> = Prisma.PrismaPromise<
    Array<
      PickEnumerable<AppInstanceGroupByOutputType, T['by']> &
        {
          [P in ((keyof T) & (keyof AppInstanceGroupByOutputType))]: P extends '_count'
            ? T[P] extends boolean
              ? number
              : GetScalarType<T[P], AppInstanceGroupByOutputType[P]>
            : GetScalarType<T[P], AppInstanceGroupByOutputType[P]>
        }
      >
    >


  export type AppInstanceSelect<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = $Extensions.GetSelect<{
    id?: boolean
    createdAt?: boolean
    photos?: boolean | AppInstance$photosArgs<ExtArgs>
    groups?: boolean | AppInstance$groupsArgs<ExtArgs>
    _count?: boolean | AppInstanceCountOutputTypeDefaultArgs<ExtArgs>
  }, ExtArgs["result"]["appInstance"]>



  export type AppInstanceSelectScalar = {
    id?: boolean
    createdAt?: boolean
  }

  export type AppInstanceOmit<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = $Extensions.GetOmit<"id" | "createdAt", ExtArgs["result"]["appInstance"]>
  export type AppInstanceInclude<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    photos?: boolean | AppInstance$photosArgs<ExtArgs>
    groups?: boolean | AppInstance$groupsArgs<ExtArgs>
    _count?: boolean | AppInstanceCountOutputTypeDefaultArgs<ExtArgs>
  }

  export type $AppInstancePayload<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    name: "AppInstance"
    objects: {
      photos: Prisma.$PhotoPayload<ExtArgs>[]
      groups: Prisma.$GroupPayload<ExtArgs>[]
    }
    scalars: $Extensions.GetPayloadResult<{
      id: number
      createdAt: Date
    }, ExtArgs["result"]["appInstance"]>
    composites: {}
  }

  type AppInstanceGetPayload<S extends boolean | null | undefined | AppInstanceDefaultArgs> = $Result.GetResult<Prisma.$AppInstancePayload, S>

  type AppInstanceCountArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> =
    Omit<AppInstanceFindManyArgs, 'select' | 'include' | 'distinct' | 'omit'> & {
      select?: AppInstanceCountAggregateInputType | true
    }

  export interface AppInstanceDelegate<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs, GlobalOmitOptions = {}> {
    [K: symbol]: { types: Prisma.TypeMap<ExtArgs>['model']['AppInstance'], meta: { name: 'AppInstance' } }
    /**
     * Find zero or one AppInstance that matches the filter.
     * @param {AppInstanceFindUniqueArgs} args - Arguments to find a AppInstance
     * @example
     * // Get one AppInstance
     * const appInstance = await prisma.appInstance.findUnique({
     *   where: {
     *     // ... provide filter here
     *   }
     * })
     */
    findUnique<T extends AppInstanceFindUniqueArgs>(args: SelectSubset<T, AppInstanceFindUniqueArgs<ExtArgs>>): Prisma__AppInstanceClient<$Result.GetResult<Prisma.$AppInstancePayload<ExtArgs>, T, "findUnique", GlobalOmitOptions> | null, null, ExtArgs, GlobalOmitOptions>

    /**
     * Find one AppInstance that matches the filter or throw an error with `error.code='P2025'`
     * if no matches were found.
     * @param {AppInstanceFindUniqueOrThrowArgs} args - Arguments to find a AppInstance
     * @example
     * // Get one AppInstance
     * const appInstance = await prisma.appInstance.findUniqueOrThrow({
     *   where: {
     *     // ... provide filter here
     *   }
     * })
     */
    findUniqueOrThrow<T extends AppInstanceFindUniqueOrThrowArgs>(args: SelectSubset<T, AppInstanceFindUniqueOrThrowArgs<ExtArgs>>): Prisma__AppInstanceClient<$Result.GetResult<Prisma.$AppInstancePayload<ExtArgs>, T, "findUniqueOrThrow", GlobalOmitOptions>, never, ExtArgs, GlobalOmitOptions>

    /**
     * Find the first AppInstance that matches the filter.
     * Note, that providing `undefined` is treated as the value not being there.
     * Read more here: https://pris.ly/d/null-undefined
     * @param {AppInstanceFindFirstArgs} args - Arguments to find a AppInstance
     * @example
     * // Get one AppInstance
     * const appInstance = await prisma.appInstance.findFirst({
     *   where: {
     *     // ... provide filter here
     *   }
     * })
     */
    findFirst<T extends AppInstanceFindFirstArgs>(args?: SelectSubset<T, AppInstanceFindFirstArgs<ExtArgs>>): Prisma__AppInstanceClient<$Result.GetResult<Prisma.$AppInstancePayload<ExtArgs>, T, "findFirst", GlobalOmitOptions> | null, null, ExtArgs, GlobalOmitOptions>

    /**
     * Find the first AppInstance that matches the filter or
     * throw `PrismaKnownClientError` with `P2025` code if no matches were found.
     * Note, that providing `undefined` is treated as the value not being there.
     * Read more here: https://pris.ly/d/null-undefined
     * @param {AppInstanceFindFirstOrThrowArgs} args - Arguments to find a AppInstance
     * @example
     * // Get one AppInstance
     * const appInstance = await prisma.appInstance.findFirstOrThrow({
     *   where: {
     *     // ... provide filter here
     *   }
     * })
     */
    findFirstOrThrow<T extends AppInstanceFindFirstOrThrowArgs>(args?: SelectSubset<T, AppInstanceFindFirstOrThrowArgs<ExtArgs>>): Prisma__AppInstanceClient<$Result.GetResult<Prisma.$AppInstancePayload<ExtArgs>, T, "findFirstOrThrow", GlobalOmitOptions>, never, ExtArgs, GlobalOmitOptions>

    /**
     * Find zero or more AppInstances that matches the filter.
     * Note, that providing `undefined` is treated as the value not being there.
     * Read more here: https://pris.ly/d/null-undefined
     * @param {AppInstanceFindManyArgs} args - Arguments to filter and select certain fields only.
     * @example
     * // Get all AppInstances
     * const appInstances = await prisma.appInstance.findMany()
     * 
     * // Get first 10 AppInstances
     * const appInstances = await prisma.appInstance.findMany({ take: 10 })
     * 
     * // Only select the `id`
     * const appInstanceWithIdOnly = await prisma.appInstance.findMany({ select: { id: true } })
     * 
     */
    findMany<T extends AppInstanceFindManyArgs>(args?: SelectSubset<T, AppInstanceFindManyArgs<ExtArgs>>): Prisma.PrismaPromise<$Result.GetResult<Prisma.$AppInstancePayload<ExtArgs>, T, "findMany", GlobalOmitOptions>>

    /**
     * Create a AppInstance.
     * @param {AppInstanceCreateArgs} args - Arguments to create a AppInstance.
     * @example
     * // Create one AppInstance
     * const AppInstance = await prisma.appInstance.create({
     *   data: {
     *     // ... data to create a AppInstance
     *   }
     * })
     * 
     */
    create<T extends AppInstanceCreateArgs>(args: SelectSubset<T, AppInstanceCreateArgs<ExtArgs>>): Prisma__AppInstanceClient<$Result.GetResult<Prisma.$AppInstancePayload<ExtArgs>, T, "create", GlobalOmitOptions>, never, ExtArgs, GlobalOmitOptions>

    /**
     * Create many AppInstances.
     * @param {AppInstanceCreateManyArgs} args - Arguments to create many AppInstances.
     * @example
     * // Create many AppInstances
     * const appInstance = await prisma.appInstance.createMany({
     *   data: [
     *     // ... provide data here
     *   ]
     * })
     *     
     */
    createMany<T extends AppInstanceCreateManyArgs>(args?: SelectSubset<T, AppInstanceCreateManyArgs<ExtArgs>>): Prisma.PrismaPromise<BatchPayload>

    /**
     * Delete a AppInstance.
     * @param {AppInstanceDeleteArgs} args - Arguments to delete one AppInstance.
     * @example
     * // Delete one AppInstance
     * const AppInstance = await prisma.appInstance.delete({
     *   where: {
     *     // ... filter to delete one AppInstance
     *   }
     * })
     * 
     */
    delete<T extends AppInstanceDeleteArgs>(args: SelectSubset<T, AppInstanceDeleteArgs<ExtArgs>>): Prisma__AppInstanceClient<$Result.GetResult<Prisma.$AppInstancePayload<ExtArgs>, T, "delete", GlobalOmitOptions>, never, ExtArgs, GlobalOmitOptions>

    /**
     * Update one AppInstance.
     * @param {AppInstanceUpdateArgs} args - Arguments to update one AppInstance.
     * @example
     * // Update one AppInstance
     * const appInstance = await prisma.appInstance.update({
     *   where: {
     *     // ... provide filter here
     *   },
     *   data: {
     *     // ... provide data here
     *   }
     * })
     * 
     */
    update<T extends AppInstanceUpdateArgs>(args: SelectSubset<T, AppInstanceUpdateArgs<ExtArgs>>): Prisma__AppInstanceClient<$Result.GetResult<Prisma.$AppInstancePayload<ExtArgs>, T, "update", GlobalOmitOptions>, never, ExtArgs, GlobalOmitOptions>

    /**
     * Delete zero or more AppInstances.
     * @param {AppInstanceDeleteManyArgs} args - Arguments to filter AppInstances to delete.
     * @example
     * // Delete a few AppInstances
     * const { count } = await prisma.appInstance.deleteMany({
     *   where: {
     *     // ... provide filter here
     *   }
     * })
     * 
     */
    deleteMany<T extends AppInstanceDeleteManyArgs>(args?: SelectSubset<T, AppInstanceDeleteManyArgs<ExtArgs>>): Prisma.PrismaPromise<BatchPayload>

    /**
     * Update zero or more AppInstances.
     * Note, that providing `undefined` is treated as the value not being there.
     * Read more here: https://pris.ly/d/null-undefined
     * @param {AppInstanceUpdateManyArgs} args - Arguments to update one or more rows.
     * @example
     * // Update many AppInstances
     * const appInstance = await prisma.appInstance.updateMany({
     *   where: {
     *     // ... provide filter here
     *   },
     *   data: {
     *     // ... provide data here
     *   }
     * })
     * 
     */
    updateMany<T extends AppInstanceUpdateManyArgs>(args: SelectSubset<T, AppInstanceUpdateManyArgs<ExtArgs>>): Prisma.PrismaPromise<BatchPayload>

    /**
     * Create or update one AppInstance.
     * @param {AppInstanceUpsertArgs} args - Arguments to update or create a AppInstance.
     * @example
     * // Update or create a AppInstance
     * const appInstance = await prisma.appInstance.upsert({
     *   create: {
     *     // ... data to create a AppInstance
     *   },
     *   update: {
     *     // ... in case it already exists, update
     *   },
     *   where: {
     *     // ... the filter for the AppInstance we want to update
     *   }
     * })
     */
    upsert<T extends AppInstanceUpsertArgs>(args: SelectSubset<T, AppInstanceUpsertArgs<ExtArgs>>): Prisma__AppInstanceClient<$Result.GetResult<Prisma.$AppInstancePayload<ExtArgs>, T, "upsert", GlobalOmitOptions>, never, ExtArgs, GlobalOmitOptions>


    /**
     * Count the number of AppInstances.
     * Note, that providing `undefined` is treated as the value not being there.
     * Read more here: https://pris.ly/d/null-undefined
     * @param {AppInstanceCountArgs} args - Arguments to filter AppInstances to count.
     * @example
     * // Count the number of AppInstances
     * const count = await prisma.appInstance.count({
     *   where: {
     *     // ... the filter for the AppInstances we want to count
     *   }
     * })
    **/
    count<T extends AppInstanceCountArgs>(
      args?: Subset<T, AppInstanceCountArgs>,
    ): Prisma.PrismaPromise<
      T extends $Utils.Record<'select', any>
        ? T['select'] extends true
          ? number
          : GetScalarType<T['select'], AppInstanceCountAggregateOutputType>
        : number
    >

    /**
     * Allows you to perform aggregations operations on a AppInstance.
     * Note, that providing `undefined` is treated as the value not being there.
     * Read more here: https://pris.ly/d/null-undefined
     * @param {AppInstanceAggregateArgs} args - Select which aggregations you would like to apply and on what fields.
     * @example
     * // Ordered by age ascending
     * // Where email contains prisma.io
     * // Limited to the 10 users
     * const aggregations = await prisma.user.aggregate({
     *   _avg: {
     *     age: true,
     *   },
     *   where: {
     *     email: {
     *       contains: "prisma.io",
     *     },
     *   },
     *   orderBy: {
     *     age: "asc",
     *   },
     *   take: 10,
     * })
    **/
    aggregate<T extends AppInstanceAggregateArgs>(args: Subset<T, AppInstanceAggregateArgs>): Prisma.PrismaPromise<GetAppInstanceAggregateType<T>>

    /**
     * Group by AppInstance.
     * Note, that providing `undefined` is treated as the value not being there.
     * Read more here: https://pris.ly/d/null-undefined
     * @param {AppInstanceGroupByArgs} args - Group by arguments.
     * @example
     * // Group by city, order by createdAt, get count
     * const result = await prisma.user.groupBy({
     *   by: ['city', 'createdAt'],
     *   orderBy: {
     *     createdAt: true
     *   },
     *   _count: {
     *     _all: true
     *   },
     * })
     * 
    **/
    groupBy<
      T extends AppInstanceGroupByArgs,
      HasSelectOrTake extends Or<
        Extends<'skip', Keys<T>>,
        Extends<'take', Keys<T>>
      >,
      OrderByArg extends True extends HasSelectOrTake
        ? { orderBy: AppInstanceGroupByArgs['orderBy'] }
        : { orderBy?: AppInstanceGroupByArgs['orderBy'] },
      OrderFields extends ExcludeUnderscoreKeys<Keys<MaybeTupleToUnion<T['orderBy']>>>,
      ByFields extends MaybeTupleToUnion<T['by']>,
      ByValid extends Has<ByFields, OrderFields>,
      HavingFields extends GetHavingFields<T['having']>,
      HavingValid extends Has<ByFields, HavingFields>,
      ByEmpty extends T['by'] extends never[] ? True : False,
      InputErrors extends ByEmpty extends True
      ? `Error: "by" must not be empty.`
      : HavingValid extends False
      ? {
          [P in HavingFields]: P extends ByFields
            ? never
            : P extends string
            ? `Error: Field "${P}" used in "having" needs to be provided in "by".`
            : [
                Error,
                'Field ',
                P,
                ` in "having" needs to be provided in "by"`,
              ]
        }[HavingFields]
      : 'take' extends Keys<T>
      ? 'orderBy' extends Keys<T>
        ? ByValid extends True
          ? {}
          : {
              [P in OrderFields]: P extends ByFields
                ? never
                : `Error: Field "${P}" in "orderBy" needs to be provided in "by"`
            }[OrderFields]
        : 'Error: If you provide "take", you also need to provide "orderBy"'
      : 'skip' extends Keys<T>
      ? 'orderBy' extends Keys<T>
        ? ByValid extends True
          ? {}
          : {
              [P in OrderFields]: P extends ByFields
                ? never
                : `Error: Field "${P}" in "orderBy" needs to be provided in "by"`
            }[OrderFields]
        : 'Error: If you provide "skip", you also need to provide "orderBy"'
      : ByValid extends True
      ? {}
      : {
          [P in OrderFields]: P extends ByFields
            ? never
            : `Error: Field "${P}" in "orderBy" needs to be provided in "by"`
        }[OrderFields]
    >(args: SubsetIntersection<T, AppInstanceGroupByArgs, OrderByArg> & InputErrors): {} extends InputErrors ? GetAppInstanceGroupByPayload<T> : Prisma.PrismaPromise<InputErrors>
  /**
   * Fields of the AppInstance model
   */
  readonly fields: AppInstanceFieldRefs;
  }

  /**
   * The delegate class that acts as a "Promise-like" for AppInstance.
   * Why is this prefixed with `Prisma__`?
   * Because we want to prevent naming conflicts as mentioned in
   * https://github.com/prisma/prisma-client-js/issues/707
   */
  export interface Prisma__AppInstanceClient<T, Null = never, ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs, GlobalOmitOptions = {}> extends Prisma.PrismaPromise<T> {
    readonly [Symbol.toStringTag]: "PrismaPromise"
    photos<T extends AppInstance$photosArgs<ExtArgs> = {}>(args?: Subset<T, AppInstance$photosArgs<ExtArgs>>): Prisma.PrismaPromise<$Result.GetResult<Prisma.$PhotoPayload<ExtArgs>, T, "findMany", GlobalOmitOptions> | Null>
    groups<T extends AppInstance$groupsArgs<ExtArgs> = {}>(args?: Subset<T, AppInstance$groupsArgs<ExtArgs>>): Prisma.PrismaPromise<$Result.GetResult<Prisma.$GroupPayload<ExtArgs>, T, "findMany", GlobalOmitOptions> | Null>
    /**
     * Attaches callbacks for the resolution and/or rejection of the Promise.
     * @param onfulfilled The callback to execute when the Promise is resolved.
     * @param onrejected The callback to execute when the Promise is rejected.
     * @returns A Promise for the completion of which ever callback is executed.
     */
    then<TResult1 = T, TResult2 = never>(onfulfilled?: ((value: T) => TResult1 | PromiseLike<TResult1>) | undefined | null, onrejected?: ((reason: any) => TResult2 | PromiseLike<TResult2>) | undefined | null): $Utils.JsPromise<TResult1 | TResult2>
    /**
     * Attaches a callback for only the rejection of the Promise.
     * @param onrejected The callback to execute when the Promise is rejected.
     * @returns A Promise for the completion of the callback.
     */
    catch<TResult = never>(onrejected?: ((reason: any) => TResult | PromiseLike<TResult>) | undefined | null): $Utils.JsPromise<T | TResult>
    /**
     * Attaches a callback that is invoked when the Promise is settled (fulfilled or rejected). The
     * resolved value cannot be modified from the callback.
     * @param onfinally The callback to execute when the Promise is settled (fulfilled or rejected).
     * @returns A Promise for the completion of the callback.
     */
    finally(onfinally?: (() => void) | undefined | null): $Utils.JsPromise<T>
  }




  /**
   * Fields of the AppInstance model
   */
  interface AppInstanceFieldRefs {
    readonly id: FieldRef<"AppInstance", 'Int'>
    readonly createdAt: FieldRef<"AppInstance", 'DateTime'>
  }
    

  // Custom InputTypes
  /**
   * AppInstance findUnique
   */
  export type AppInstanceFindUniqueArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the AppInstance
     */
    select?: AppInstanceSelect<ExtArgs> | null
    /**
     * Omit specific fields from the AppInstance
     */
    omit?: AppInstanceOmit<ExtArgs> | null
    /**
     * Choose, which related nodes to fetch as well
     */
    include?: AppInstanceInclude<ExtArgs> | null
    /**
     * Filter, which AppInstance to fetch.
     */
    where: AppInstanceWhereUniqueInput
  }

  /**
   * AppInstance findUniqueOrThrow
   */
  export type AppInstanceFindUniqueOrThrowArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the AppInstance
     */
    select?: AppInstanceSelect<ExtArgs> | null
    /**
     * Omit specific fields from the AppInstance
     */
    omit?: AppInstanceOmit<ExtArgs> | null
    /**
     * Choose, which related nodes to fetch as well
     */
    include?: AppInstanceInclude<ExtArgs> | null
    /**
     * Filter, which AppInstance to fetch.
     */
    where: AppInstanceWhereUniqueInput
  }

  /**
   * AppInstance findFirst
   */
  export type AppInstanceFindFirstArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the AppInstance
     */
    select?: AppInstanceSelect<ExtArgs> | null
    /**
     * Omit specific fields from the AppInstance
     */
    omit?: AppInstanceOmit<ExtArgs> | null
    /**
     * Choose, which related nodes to fetch as well
     */
    include?: AppInstanceInclude<ExtArgs> | null
    /**
     * Filter, which AppInstance to fetch.
     */
    where?: AppInstanceWhereInput
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/sorting Sorting Docs}
     * 
     * Determine the order of AppInstances to fetch.
     */
    orderBy?: AppInstanceOrderByWithRelationInput | AppInstanceOrderByWithRelationInput[]
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination#cursor-based-pagination Cursor Docs}
     * 
     * Sets the position for searching for AppInstances.
     */
    cursor?: AppInstanceWhereUniqueInput
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination Pagination Docs}
     * 
     * Take `±n` AppInstances from the position of the cursor.
     */
    take?: number
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination Pagination Docs}
     * 
     * Skip the first `n` AppInstances.
     */
    skip?: number
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/distinct Distinct Docs}
     * 
     * Filter by unique combinations of AppInstances.
     */
    distinct?: AppInstanceScalarFieldEnum | AppInstanceScalarFieldEnum[]
  }

  /**
   * AppInstance findFirstOrThrow
   */
  export type AppInstanceFindFirstOrThrowArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the AppInstance
     */
    select?: AppInstanceSelect<ExtArgs> | null
    /**
     * Omit specific fields from the AppInstance
     */
    omit?: AppInstanceOmit<ExtArgs> | null
    /**
     * Choose, which related nodes to fetch as well
     */
    include?: AppInstanceInclude<ExtArgs> | null
    /**
     * Filter, which AppInstance to fetch.
     */
    where?: AppInstanceWhereInput
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/sorting Sorting Docs}
     * 
     * Determine the order of AppInstances to fetch.
     */
    orderBy?: AppInstanceOrderByWithRelationInput | AppInstanceOrderByWithRelationInput[]
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination#cursor-based-pagination Cursor Docs}
     * 
     * Sets the position for searching for AppInstances.
     */
    cursor?: AppInstanceWhereUniqueInput
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination Pagination Docs}
     * 
     * Take `±n` AppInstances from the position of the cursor.
     */
    take?: number
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination Pagination Docs}
     * 
     * Skip the first `n` AppInstances.
     */
    skip?: number
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/distinct Distinct Docs}
     * 
     * Filter by unique combinations of AppInstances.
     */
    distinct?: AppInstanceScalarFieldEnum | AppInstanceScalarFieldEnum[]
  }

  /**
   * AppInstance findMany
   */
  export type AppInstanceFindManyArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the AppInstance
     */
    select?: AppInstanceSelect<ExtArgs> | null
    /**
     * Omit specific fields from the AppInstance
     */
    omit?: AppInstanceOmit<ExtArgs> | null
    /**
     * Choose, which related nodes to fetch as well
     */
    include?: AppInstanceInclude<ExtArgs> | null
    /**
     * Filter, which AppInstances to fetch.
     */
    where?: AppInstanceWhereInput
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/sorting Sorting Docs}
     * 
     * Determine the order of AppInstances to fetch.
     */
    orderBy?: AppInstanceOrderByWithRelationInput | AppInstanceOrderByWithRelationInput[]
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination#cursor-based-pagination Cursor Docs}
     * 
     * Sets the position for listing AppInstances.
     */
    cursor?: AppInstanceWhereUniqueInput
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination Pagination Docs}
     * 
     * Take `±n` AppInstances from the position of the cursor.
     */
    take?: number
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination Pagination Docs}
     * 
     * Skip the first `n` AppInstances.
     */
    skip?: number
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/distinct Distinct Docs}
     * 
     * Filter by unique combinations of AppInstances.
     */
    distinct?: AppInstanceScalarFieldEnum | AppInstanceScalarFieldEnum[]
  }

  /**
   * AppInstance create
   */
  export type AppInstanceCreateArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the AppInstance
     */
    select?: AppInstanceSelect<ExtArgs> | null
    /**
     * Omit specific fields from the AppInstance
     */
    omit?: AppInstanceOmit<ExtArgs> | null
    /**
     * Choose, which related nodes to fetch as well
     */
    include?: AppInstanceInclude<ExtArgs> | null
    /**
     * The data needed to create a AppInstance.
     */
    data?: XOR<AppInstanceCreateInput, AppInstanceUncheckedCreateInput>
  }

  /**
   * AppInstance createMany
   */
  export type AppInstanceCreateManyArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * The data used to create many AppInstances.
     */
    data: AppInstanceCreateManyInput | AppInstanceCreateManyInput[]
    skipDuplicates?: boolean
  }

  /**
   * AppInstance update
   */
  export type AppInstanceUpdateArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the AppInstance
     */
    select?: AppInstanceSelect<ExtArgs> | null
    /**
     * Omit specific fields from the AppInstance
     */
    omit?: AppInstanceOmit<ExtArgs> | null
    /**
     * Choose, which related nodes to fetch as well
     */
    include?: AppInstanceInclude<ExtArgs> | null
    /**
     * The data needed to update a AppInstance.
     */
    data: XOR<AppInstanceUpdateInput, AppInstanceUncheckedUpdateInput>
    /**
     * Choose, which AppInstance to update.
     */
    where: AppInstanceWhereUniqueInput
  }

  /**
   * AppInstance updateMany
   */
  export type AppInstanceUpdateManyArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * The data used to update AppInstances.
     */
    data: XOR<AppInstanceUpdateManyMutationInput, AppInstanceUncheckedUpdateManyInput>
    /**
     * Filter which AppInstances to update
     */
    where?: AppInstanceWhereInput
    /**
     * Limit how many AppInstances to update.
     */
    limit?: number
  }

  /**
   * AppInstance upsert
   */
  export type AppInstanceUpsertArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the AppInstance
     */
    select?: AppInstanceSelect<ExtArgs> | null
    /**
     * Omit specific fields from the AppInstance
     */
    omit?: AppInstanceOmit<ExtArgs> | null
    /**
     * Choose, which related nodes to fetch as well
     */
    include?: AppInstanceInclude<ExtArgs> | null
    /**
     * The filter to search for the AppInstance to update in case it exists.
     */
    where: AppInstanceWhereUniqueInput
    /**
     * In case the AppInstance found by the `where` argument doesn't exist, create a new AppInstance with this data.
     */
    create: XOR<AppInstanceCreateInput, AppInstanceUncheckedCreateInput>
    /**
     * In case the AppInstance was found with the provided `where` argument, update it with this data.
     */
    update: XOR<AppInstanceUpdateInput, AppInstanceUncheckedUpdateInput>
  }

  /**
   * AppInstance delete
   */
  export type AppInstanceDeleteArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the AppInstance
     */
    select?: AppInstanceSelect<ExtArgs> | null
    /**
     * Omit specific fields from the AppInstance
     */
    omit?: AppInstanceOmit<ExtArgs> | null
    /**
     * Choose, which related nodes to fetch as well
     */
    include?: AppInstanceInclude<ExtArgs> | null
    /**
     * Filter which AppInstance to delete.
     */
    where: AppInstanceWhereUniqueInput
  }

  /**
   * AppInstance deleteMany
   */
  export type AppInstanceDeleteManyArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Filter which AppInstances to delete
     */
    where?: AppInstanceWhereInput
    /**
     * Limit how many AppInstances to delete.
     */
    limit?: number
  }

  /**
   * AppInstance.photos
   */
  export type AppInstance$photosArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the Photo
     */
    select?: PhotoSelect<ExtArgs> | null
    /**
     * Omit specific fields from the Photo
     */
    omit?: PhotoOmit<ExtArgs> | null
    /**
     * Choose, which related nodes to fetch as well
     */
    include?: PhotoInclude<ExtArgs> | null
    where?: PhotoWhereInput
    orderBy?: PhotoOrderByWithRelationInput | PhotoOrderByWithRelationInput[]
    cursor?: PhotoWhereUniqueInput
    take?: number
    skip?: number
    distinct?: PhotoScalarFieldEnum | PhotoScalarFieldEnum[]
  }

  /**
   * AppInstance.groups
   */
  export type AppInstance$groupsArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the Group
     */
    select?: GroupSelect<ExtArgs> | null
    /**
     * Omit specific fields from the Group
     */
    omit?: GroupOmit<ExtArgs> | null
    /**
     * Choose, which related nodes to fetch as well
     */
    include?: GroupInclude<ExtArgs> | null
    where?: GroupWhereInput
    orderBy?: GroupOrderByWithRelationInput | GroupOrderByWithRelationInput[]
    cursor?: GroupWhereUniqueInput
    take?: number
    skip?: number
    distinct?: GroupScalarFieldEnum | GroupScalarFieldEnum[]
  }

  /**
   * AppInstance without action
   */
  export type AppInstanceDefaultArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the AppInstance
     */
    select?: AppInstanceSelect<ExtArgs> | null
    /**
     * Omit specific fields from the AppInstance
     */
    omit?: AppInstanceOmit<ExtArgs> | null
    /**
     * Choose, which related nodes to fetch as well
     */
    include?: AppInstanceInclude<ExtArgs> | null
  }


  /**
   * Model Photo
   */

  export type AggregatePhoto = {
    _count: PhotoCountAggregateOutputType | null
    _avg: PhotoAvgAggregateOutputType | null
    _sum: PhotoSumAggregateOutputType | null
    _min: PhotoMinAggregateOutputType | null
    _max: PhotoMaxAggregateOutputType | null
  }

  export type PhotoAvgAggregateOutputType = {
    id: number | null
    appInstanceId: number | null
  }

  export type PhotoSumAggregateOutputType = {
    id: number | null
    appInstanceId: number | null
  }

  export type PhotoMinAggregateOutputType = {
    id: number | null
    appInstanceId: number | null
    imagePath: string | null
    createdAt: Date | null
  }

  export type PhotoMaxAggregateOutputType = {
    id: number | null
    appInstanceId: number | null
    imagePath: string | null
    createdAt: Date | null
  }

  export type PhotoCountAggregateOutputType = {
    id: number
    appInstanceId: number
    imagePath: number
    createdAt: number
    _all: number
  }


  export type PhotoAvgAggregateInputType = {
    id?: true
    appInstanceId?: true
  }

  export type PhotoSumAggregateInputType = {
    id?: true
    appInstanceId?: true
  }

  export type PhotoMinAggregateInputType = {
    id?: true
    appInstanceId?: true
    imagePath?: true
    createdAt?: true
  }

  export type PhotoMaxAggregateInputType = {
    id?: true
    appInstanceId?: true
    imagePath?: true
    createdAt?: true
  }

  export type PhotoCountAggregateInputType = {
    id?: true
    appInstanceId?: true
    imagePath?: true
    createdAt?: true
    _all?: true
  }

  export type PhotoAggregateArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Filter which Photo to aggregate.
     */
    where?: PhotoWhereInput
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/sorting Sorting Docs}
     * 
     * Determine the order of Photos to fetch.
     */
    orderBy?: PhotoOrderByWithRelationInput | PhotoOrderByWithRelationInput[]
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination#cursor-based-pagination Cursor Docs}
     * 
     * Sets the start position
     */
    cursor?: PhotoWhereUniqueInput
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination Pagination Docs}
     * 
     * Take `±n` Photos from the position of the cursor.
     */
    take?: number
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination Pagination Docs}
     * 
     * Skip the first `n` Photos.
     */
    skip?: number
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/aggregations Aggregation Docs}
     * 
     * Count returned Photos
    **/
    _count?: true | PhotoCountAggregateInputType
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/aggregations Aggregation Docs}
     * 
     * Select which fields to average
    **/
    _avg?: PhotoAvgAggregateInputType
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/aggregations Aggregation Docs}
     * 
     * Select which fields to sum
    **/
    _sum?: PhotoSumAggregateInputType
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/aggregations Aggregation Docs}
     * 
     * Select which fields to find the minimum value
    **/
    _min?: PhotoMinAggregateInputType
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/aggregations Aggregation Docs}
     * 
     * Select which fields to find the maximum value
    **/
    _max?: PhotoMaxAggregateInputType
  }

  export type GetPhotoAggregateType<T extends PhotoAggregateArgs> = {
        [P in keyof T & keyof AggregatePhoto]: P extends '_count' | 'count'
      ? T[P] extends true
        ? number
        : GetScalarType<T[P], AggregatePhoto[P]>
      : GetScalarType<T[P], AggregatePhoto[P]>
  }




  export type PhotoGroupByArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    where?: PhotoWhereInput
    orderBy?: PhotoOrderByWithAggregationInput | PhotoOrderByWithAggregationInput[]
    by: PhotoScalarFieldEnum[] | PhotoScalarFieldEnum
    having?: PhotoScalarWhereWithAggregatesInput
    take?: number
    skip?: number
    _count?: PhotoCountAggregateInputType | true
    _avg?: PhotoAvgAggregateInputType
    _sum?: PhotoSumAggregateInputType
    _min?: PhotoMinAggregateInputType
    _max?: PhotoMaxAggregateInputType
  }

  export type PhotoGroupByOutputType = {
    id: number
    appInstanceId: number
    imagePath: string
    createdAt: Date
    _count: PhotoCountAggregateOutputType | null
    _avg: PhotoAvgAggregateOutputType | null
    _sum: PhotoSumAggregateOutputType | null
    _min: PhotoMinAggregateOutputType | null
    _max: PhotoMaxAggregateOutputType | null
  }

  type GetPhotoGroupByPayload<T extends PhotoGroupByArgs> = Prisma.PrismaPromise<
    Array<
      PickEnumerable<PhotoGroupByOutputType, T['by']> &
        {
          [P in ((keyof T) & (keyof PhotoGroupByOutputType))]: P extends '_count'
            ? T[P] extends boolean
              ? number
              : GetScalarType<T[P], PhotoGroupByOutputType[P]>
            : GetScalarType<T[P], PhotoGroupByOutputType[P]>
        }
      >
    >


  export type PhotoSelect<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = $Extensions.GetSelect<{
    id?: boolean
    appInstanceId?: boolean
    imagePath?: boolean
    createdAt?: boolean
    appInstance?: boolean | AppInstanceDefaultArgs<ExtArgs>
    faces?: boolean | Photo$facesArgs<ExtArgs>
    _count?: boolean | PhotoCountOutputTypeDefaultArgs<ExtArgs>
  }, ExtArgs["result"]["photo"]>



  export type PhotoSelectScalar = {
    id?: boolean
    appInstanceId?: boolean
    imagePath?: boolean
    createdAt?: boolean
  }

  export type PhotoOmit<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = $Extensions.GetOmit<"id" | "appInstanceId" | "imagePath" | "createdAt", ExtArgs["result"]["photo"]>
  export type PhotoInclude<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    appInstance?: boolean | AppInstanceDefaultArgs<ExtArgs>
    faces?: boolean | Photo$facesArgs<ExtArgs>
    _count?: boolean | PhotoCountOutputTypeDefaultArgs<ExtArgs>
  }

  export type $PhotoPayload<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    name: "Photo"
    objects: {
      appInstance: Prisma.$AppInstancePayload<ExtArgs>
      faces: Prisma.$FacePayload<ExtArgs>[]
    }
    scalars: $Extensions.GetPayloadResult<{
      id: number
      appInstanceId: number
      imagePath: string
      createdAt: Date
    }, ExtArgs["result"]["photo"]>
    composites: {}
  }

  type PhotoGetPayload<S extends boolean | null | undefined | PhotoDefaultArgs> = $Result.GetResult<Prisma.$PhotoPayload, S>

  type PhotoCountArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> =
    Omit<PhotoFindManyArgs, 'select' | 'include' | 'distinct' | 'omit'> & {
      select?: PhotoCountAggregateInputType | true
    }

  export interface PhotoDelegate<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs, GlobalOmitOptions = {}> {
    [K: symbol]: { types: Prisma.TypeMap<ExtArgs>['model']['Photo'], meta: { name: 'Photo' } }
    /**
     * Find zero or one Photo that matches the filter.
     * @param {PhotoFindUniqueArgs} args - Arguments to find a Photo
     * @example
     * // Get one Photo
     * const photo = await prisma.photo.findUnique({
     *   where: {
     *     // ... provide filter here
     *   }
     * })
     */
    findUnique<T extends PhotoFindUniqueArgs>(args: SelectSubset<T, PhotoFindUniqueArgs<ExtArgs>>): Prisma__PhotoClient<$Result.GetResult<Prisma.$PhotoPayload<ExtArgs>, T, "findUnique", GlobalOmitOptions> | null, null, ExtArgs, GlobalOmitOptions>

    /**
     * Find one Photo that matches the filter or throw an error with `error.code='P2025'`
     * if no matches were found.
     * @param {PhotoFindUniqueOrThrowArgs} args - Arguments to find a Photo
     * @example
     * // Get one Photo
     * const photo = await prisma.photo.findUniqueOrThrow({
     *   where: {
     *     // ... provide filter here
     *   }
     * })
     */
    findUniqueOrThrow<T extends PhotoFindUniqueOrThrowArgs>(args: SelectSubset<T, PhotoFindUniqueOrThrowArgs<ExtArgs>>): Prisma__PhotoClient<$Result.GetResult<Prisma.$PhotoPayload<ExtArgs>, T, "findUniqueOrThrow", GlobalOmitOptions>, never, ExtArgs, GlobalOmitOptions>

    /**
     * Find the first Photo that matches the filter.
     * Note, that providing `undefined` is treated as the value not being there.
     * Read more here: https://pris.ly/d/null-undefined
     * @param {PhotoFindFirstArgs} args - Arguments to find a Photo
     * @example
     * // Get one Photo
     * const photo = await prisma.photo.findFirst({
     *   where: {
     *     // ... provide filter here
     *   }
     * })
     */
    findFirst<T extends PhotoFindFirstArgs>(args?: SelectSubset<T, PhotoFindFirstArgs<ExtArgs>>): Prisma__PhotoClient<$Result.GetResult<Prisma.$PhotoPayload<ExtArgs>, T, "findFirst", GlobalOmitOptions> | null, null, ExtArgs, GlobalOmitOptions>

    /**
     * Find the first Photo that matches the filter or
     * throw `PrismaKnownClientError` with `P2025` code if no matches were found.
     * Note, that providing `undefined` is treated as the value not being there.
     * Read more here: https://pris.ly/d/null-undefined
     * @param {PhotoFindFirstOrThrowArgs} args - Arguments to find a Photo
     * @example
     * // Get one Photo
     * const photo = await prisma.photo.findFirstOrThrow({
     *   where: {
     *     // ... provide filter here
     *   }
     * })
     */
    findFirstOrThrow<T extends PhotoFindFirstOrThrowArgs>(args?: SelectSubset<T, PhotoFindFirstOrThrowArgs<ExtArgs>>): Prisma__PhotoClient<$Result.GetResult<Prisma.$PhotoPayload<ExtArgs>, T, "findFirstOrThrow", GlobalOmitOptions>, never, ExtArgs, GlobalOmitOptions>

    /**
     * Find zero or more Photos that matches the filter.
     * Note, that providing `undefined` is treated as the value not being there.
     * Read more here: https://pris.ly/d/null-undefined
     * @param {PhotoFindManyArgs} args - Arguments to filter and select certain fields only.
     * @example
     * // Get all Photos
     * const photos = await prisma.photo.findMany()
     * 
     * // Get first 10 Photos
     * const photos = await prisma.photo.findMany({ take: 10 })
     * 
     * // Only select the `id`
     * const photoWithIdOnly = await prisma.photo.findMany({ select: { id: true } })
     * 
     */
    findMany<T extends PhotoFindManyArgs>(args?: SelectSubset<T, PhotoFindManyArgs<ExtArgs>>): Prisma.PrismaPromise<$Result.GetResult<Prisma.$PhotoPayload<ExtArgs>, T, "findMany", GlobalOmitOptions>>

    /**
     * Create a Photo.
     * @param {PhotoCreateArgs} args - Arguments to create a Photo.
     * @example
     * // Create one Photo
     * const Photo = await prisma.photo.create({
     *   data: {
     *     // ... data to create a Photo
     *   }
     * })
     * 
     */
    create<T extends PhotoCreateArgs>(args: SelectSubset<T, PhotoCreateArgs<ExtArgs>>): Prisma__PhotoClient<$Result.GetResult<Prisma.$PhotoPayload<ExtArgs>, T, "create", GlobalOmitOptions>, never, ExtArgs, GlobalOmitOptions>

    /**
     * Create many Photos.
     * @param {PhotoCreateManyArgs} args - Arguments to create many Photos.
     * @example
     * // Create many Photos
     * const photo = await prisma.photo.createMany({
     *   data: [
     *     // ... provide data here
     *   ]
     * })
     *     
     */
    createMany<T extends PhotoCreateManyArgs>(args?: SelectSubset<T, PhotoCreateManyArgs<ExtArgs>>): Prisma.PrismaPromise<BatchPayload>

    /**
     * Delete a Photo.
     * @param {PhotoDeleteArgs} args - Arguments to delete one Photo.
     * @example
     * // Delete one Photo
     * const Photo = await prisma.photo.delete({
     *   where: {
     *     // ... filter to delete one Photo
     *   }
     * })
     * 
     */
    delete<T extends PhotoDeleteArgs>(args: SelectSubset<T, PhotoDeleteArgs<ExtArgs>>): Prisma__PhotoClient<$Result.GetResult<Prisma.$PhotoPayload<ExtArgs>, T, "delete", GlobalOmitOptions>, never, ExtArgs, GlobalOmitOptions>

    /**
     * Update one Photo.
     * @param {PhotoUpdateArgs} args - Arguments to update one Photo.
     * @example
     * // Update one Photo
     * const photo = await prisma.photo.update({
     *   where: {
     *     // ... provide filter here
     *   },
     *   data: {
     *     // ... provide data here
     *   }
     * })
     * 
     */
    update<T extends PhotoUpdateArgs>(args: SelectSubset<T, PhotoUpdateArgs<ExtArgs>>): Prisma__PhotoClient<$Result.GetResult<Prisma.$PhotoPayload<ExtArgs>, T, "update", GlobalOmitOptions>, never, ExtArgs, GlobalOmitOptions>

    /**
     * Delete zero or more Photos.
     * @param {PhotoDeleteManyArgs} args - Arguments to filter Photos to delete.
     * @example
     * // Delete a few Photos
     * const { count } = await prisma.photo.deleteMany({
     *   where: {
     *     // ... provide filter here
     *   }
     * })
     * 
     */
    deleteMany<T extends PhotoDeleteManyArgs>(args?: SelectSubset<T, PhotoDeleteManyArgs<ExtArgs>>): Prisma.PrismaPromise<BatchPayload>

    /**
     * Update zero or more Photos.
     * Note, that providing `undefined` is treated as the value not being there.
     * Read more here: https://pris.ly/d/null-undefined
     * @param {PhotoUpdateManyArgs} args - Arguments to update one or more rows.
     * @example
     * // Update many Photos
     * const photo = await prisma.photo.updateMany({
     *   where: {
     *     // ... provide filter here
     *   },
     *   data: {
     *     // ... provide data here
     *   }
     * })
     * 
     */
    updateMany<T extends PhotoUpdateManyArgs>(args: SelectSubset<T, PhotoUpdateManyArgs<ExtArgs>>): Prisma.PrismaPromise<BatchPayload>

    /**
     * Create or update one Photo.
     * @param {PhotoUpsertArgs} args - Arguments to update or create a Photo.
     * @example
     * // Update or create a Photo
     * const photo = await prisma.photo.upsert({
     *   create: {
     *     // ... data to create a Photo
     *   },
     *   update: {
     *     // ... in case it already exists, update
     *   },
     *   where: {
     *     // ... the filter for the Photo we want to update
     *   }
     * })
     */
    upsert<T extends PhotoUpsertArgs>(args: SelectSubset<T, PhotoUpsertArgs<ExtArgs>>): Prisma__PhotoClient<$Result.GetResult<Prisma.$PhotoPayload<ExtArgs>, T, "upsert", GlobalOmitOptions>, never, ExtArgs, GlobalOmitOptions>


    /**
     * Count the number of Photos.
     * Note, that providing `undefined` is treated as the value not being there.
     * Read more here: https://pris.ly/d/null-undefined
     * @param {PhotoCountArgs} args - Arguments to filter Photos to count.
     * @example
     * // Count the number of Photos
     * const count = await prisma.photo.count({
     *   where: {
     *     // ... the filter for the Photos we want to count
     *   }
     * })
    **/
    count<T extends PhotoCountArgs>(
      args?: Subset<T, PhotoCountArgs>,
    ): Prisma.PrismaPromise<
      T extends $Utils.Record<'select', any>
        ? T['select'] extends true
          ? number
          : GetScalarType<T['select'], PhotoCountAggregateOutputType>
        : number
    >

    /**
     * Allows you to perform aggregations operations on a Photo.
     * Note, that providing `undefined` is treated as the value not being there.
     * Read more here: https://pris.ly/d/null-undefined
     * @param {PhotoAggregateArgs} args - Select which aggregations you would like to apply and on what fields.
     * @example
     * // Ordered by age ascending
     * // Where email contains prisma.io
     * // Limited to the 10 users
     * const aggregations = await prisma.user.aggregate({
     *   _avg: {
     *     age: true,
     *   },
     *   where: {
     *     email: {
     *       contains: "prisma.io",
     *     },
     *   },
     *   orderBy: {
     *     age: "asc",
     *   },
     *   take: 10,
     * })
    **/
    aggregate<T extends PhotoAggregateArgs>(args: Subset<T, PhotoAggregateArgs>): Prisma.PrismaPromise<GetPhotoAggregateType<T>>

    /**
     * Group by Photo.
     * Note, that providing `undefined` is treated as the value not being there.
     * Read more here: https://pris.ly/d/null-undefined
     * @param {PhotoGroupByArgs} args - Group by arguments.
     * @example
     * // Group by city, order by createdAt, get count
     * const result = await prisma.user.groupBy({
     *   by: ['city', 'createdAt'],
     *   orderBy: {
     *     createdAt: true
     *   },
     *   _count: {
     *     _all: true
     *   },
     * })
     * 
    **/
    groupBy<
      T extends PhotoGroupByArgs,
      HasSelectOrTake extends Or<
        Extends<'skip', Keys<T>>,
        Extends<'take', Keys<T>>
      >,
      OrderByArg extends True extends HasSelectOrTake
        ? { orderBy: PhotoGroupByArgs['orderBy'] }
        : { orderBy?: PhotoGroupByArgs['orderBy'] },
      OrderFields extends ExcludeUnderscoreKeys<Keys<MaybeTupleToUnion<T['orderBy']>>>,
      ByFields extends MaybeTupleToUnion<T['by']>,
      ByValid extends Has<ByFields, OrderFields>,
      HavingFields extends GetHavingFields<T['having']>,
      HavingValid extends Has<ByFields, HavingFields>,
      ByEmpty extends T['by'] extends never[] ? True : False,
      InputErrors extends ByEmpty extends True
      ? `Error: "by" must not be empty.`
      : HavingValid extends False
      ? {
          [P in HavingFields]: P extends ByFields
            ? never
            : P extends string
            ? `Error: Field "${P}" used in "having" needs to be provided in "by".`
            : [
                Error,
                'Field ',
                P,
                ` in "having" needs to be provided in "by"`,
              ]
        }[HavingFields]
      : 'take' extends Keys<T>
      ? 'orderBy' extends Keys<T>
        ? ByValid extends True
          ? {}
          : {
              [P in OrderFields]: P extends ByFields
                ? never
                : `Error: Field "${P}" in "orderBy" needs to be provided in "by"`
            }[OrderFields]
        : 'Error: If you provide "take", you also need to provide "orderBy"'
      : 'skip' extends Keys<T>
      ? 'orderBy' extends Keys<T>
        ? ByValid extends True
          ? {}
          : {
              [P in OrderFields]: P extends ByFields
                ? never
                : `Error: Field "${P}" in "orderBy" needs to be provided in "by"`
            }[OrderFields]
        : 'Error: If you provide "skip", you also need to provide "orderBy"'
      : ByValid extends True
      ? {}
      : {
          [P in OrderFields]: P extends ByFields
            ? never
            : `Error: Field "${P}" in "orderBy" needs to be provided in "by"`
        }[OrderFields]
    >(args: SubsetIntersection<T, PhotoGroupByArgs, OrderByArg> & InputErrors): {} extends InputErrors ? GetPhotoGroupByPayload<T> : Prisma.PrismaPromise<InputErrors>
  /**
   * Fields of the Photo model
   */
  readonly fields: PhotoFieldRefs;
  }

  /**
   * The delegate class that acts as a "Promise-like" for Photo.
   * Why is this prefixed with `Prisma__`?
   * Because we want to prevent naming conflicts as mentioned in
   * https://github.com/prisma/prisma-client-js/issues/707
   */
  export interface Prisma__PhotoClient<T, Null = never, ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs, GlobalOmitOptions = {}> extends Prisma.PrismaPromise<T> {
    readonly [Symbol.toStringTag]: "PrismaPromise"
    appInstance<T extends AppInstanceDefaultArgs<ExtArgs> = {}>(args?: Subset<T, AppInstanceDefaultArgs<ExtArgs>>): Prisma__AppInstanceClient<$Result.GetResult<Prisma.$AppInstancePayload<ExtArgs>, T, "findUniqueOrThrow", GlobalOmitOptions> | Null, Null, ExtArgs, GlobalOmitOptions>
    faces<T extends Photo$facesArgs<ExtArgs> = {}>(args?: Subset<T, Photo$facesArgs<ExtArgs>>): Prisma.PrismaPromise<$Result.GetResult<Prisma.$FacePayload<ExtArgs>, T, "findMany", GlobalOmitOptions> | Null>
    /**
     * Attaches callbacks for the resolution and/or rejection of the Promise.
     * @param onfulfilled The callback to execute when the Promise is resolved.
     * @param onrejected The callback to execute when the Promise is rejected.
     * @returns A Promise for the completion of which ever callback is executed.
     */
    then<TResult1 = T, TResult2 = never>(onfulfilled?: ((value: T) => TResult1 | PromiseLike<TResult1>) | undefined | null, onrejected?: ((reason: any) => TResult2 | PromiseLike<TResult2>) | undefined | null): $Utils.JsPromise<TResult1 | TResult2>
    /**
     * Attaches a callback for only the rejection of the Promise.
     * @param onrejected The callback to execute when the Promise is rejected.
     * @returns A Promise for the completion of the callback.
     */
    catch<TResult = never>(onrejected?: ((reason: any) => TResult | PromiseLike<TResult>) | undefined | null): $Utils.JsPromise<T | TResult>
    /**
     * Attaches a callback that is invoked when the Promise is settled (fulfilled or rejected). The
     * resolved value cannot be modified from the callback.
     * @param onfinally The callback to execute when the Promise is settled (fulfilled or rejected).
     * @returns A Promise for the completion of the callback.
     */
    finally(onfinally?: (() => void) | undefined | null): $Utils.JsPromise<T>
  }




  /**
   * Fields of the Photo model
   */
  interface PhotoFieldRefs {
    readonly id: FieldRef<"Photo", 'Int'>
    readonly appInstanceId: FieldRef<"Photo", 'Int'>
    readonly imagePath: FieldRef<"Photo", 'String'>
    readonly createdAt: FieldRef<"Photo", 'DateTime'>
  }
    

  // Custom InputTypes
  /**
   * Photo findUnique
   */
  export type PhotoFindUniqueArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the Photo
     */
    select?: PhotoSelect<ExtArgs> | null
    /**
     * Omit specific fields from the Photo
     */
    omit?: PhotoOmit<ExtArgs> | null
    /**
     * Choose, which related nodes to fetch as well
     */
    include?: PhotoInclude<ExtArgs> | null
    /**
     * Filter, which Photo to fetch.
     */
    where: PhotoWhereUniqueInput
  }

  /**
   * Photo findUniqueOrThrow
   */
  export type PhotoFindUniqueOrThrowArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the Photo
     */
    select?: PhotoSelect<ExtArgs> | null
    /**
     * Omit specific fields from the Photo
     */
    omit?: PhotoOmit<ExtArgs> | null
    /**
     * Choose, which related nodes to fetch as well
     */
    include?: PhotoInclude<ExtArgs> | null
    /**
     * Filter, which Photo to fetch.
     */
    where: PhotoWhereUniqueInput
  }

  /**
   * Photo findFirst
   */
  export type PhotoFindFirstArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the Photo
     */
    select?: PhotoSelect<ExtArgs> | null
    /**
     * Omit specific fields from the Photo
     */
    omit?: PhotoOmit<ExtArgs> | null
    /**
     * Choose, which related nodes to fetch as well
     */
    include?: PhotoInclude<ExtArgs> | null
    /**
     * Filter, which Photo to fetch.
     */
    where?: PhotoWhereInput
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/sorting Sorting Docs}
     * 
     * Determine the order of Photos to fetch.
     */
    orderBy?: PhotoOrderByWithRelationInput | PhotoOrderByWithRelationInput[]
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination#cursor-based-pagination Cursor Docs}
     * 
     * Sets the position for searching for Photos.
     */
    cursor?: PhotoWhereUniqueInput
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination Pagination Docs}
     * 
     * Take `±n` Photos from the position of the cursor.
     */
    take?: number
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination Pagination Docs}
     * 
     * Skip the first `n` Photos.
     */
    skip?: number
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/distinct Distinct Docs}
     * 
     * Filter by unique combinations of Photos.
     */
    distinct?: PhotoScalarFieldEnum | PhotoScalarFieldEnum[]
  }

  /**
   * Photo findFirstOrThrow
   */
  export type PhotoFindFirstOrThrowArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the Photo
     */
    select?: PhotoSelect<ExtArgs> | null
    /**
     * Omit specific fields from the Photo
     */
    omit?: PhotoOmit<ExtArgs> | null
    /**
     * Choose, which related nodes to fetch as well
     */
    include?: PhotoInclude<ExtArgs> | null
    /**
     * Filter, which Photo to fetch.
     */
    where?: PhotoWhereInput
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/sorting Sorting Docs}
     * 
     * Determine the order of Photos to fetch.
     */
    orderBy?: PhotoOrderByWithRelationInput | PhotoOrderByWithRelationInput[]
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination#cursor-based-pagination Cursor Docs}
     * 
     * Sets the position for searching for Photos.
     */
    cursor?: PhotoWhereUniqueInput
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination Pagination Docs}
     * 
     * Take `±n` Photos from the position of the cursor.
     */
    take?: number
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination Pagination Docs}
     * 
     * Skip the first `n` Photos.
     */
    skip?: number
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/distinct Distinct Docs}
     * 
     * Filter by unique combinations of Photos.
     */
    distinct?: PhotoScalarFieldEnum | PhotoScalarFieldEnum[]
  }

  /**
   * Photo findMany
   */
  export type PhotoFindManyArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the Photo
     */
    select?: PhotoSelect<ExtArgs> | null
    /**
     * Omit specific fields from the Photo
     */
    omit?: PhotoOmit<ExtArgs> | null
    /**
     * Choose, which related nodes to fetch as well
     */
    include?: PhotoInclude<ExtArgs> | null
    /**
     * Filter, which Photos to fetch.
     */
    where?: PhotoWhereInput
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/sorting Sorting Docs}
     * 
     * Determine the order of Photos to fetch.
     */
    orderBy?: PhotoOrderByWithRelationInput | PhotoOrderByWithRelationInput[]
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination#cursor-based-pagination Cursor Docs}
     * 
     * Sets the position for listing Photos.
     */
    cursor?: PhotoWhereUniqueInput
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination Pagination Docs}
     * 
     * Take `±n` Photos from the position of the cursor.
     */
    take?: number
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination Pagination Docs}
     * 
     * Skip the first `n` Photos.
     */
    skip?: number
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/distinct Distinct Docs}
     * 
     * Filter by unique combinations of Photos.
     */
    distinct?: PhotoScalarFieldEnum | PhotoScalarFieldEnum[]
  }

  /**
   * Photo create
   */
  export type PhotoCreateArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the Photo
     */
    select?: PhotoSelect<ExtArgs> | null
    /**
     * Omit specific fields from the Photo
     */
    omit?: PhotoOmit<ExtArgs> | null
    /**
     * Choose, which related nodes to fetch as well
     */
    include?: PhotoInclude<ExtArgs> | null
    /**
     * The data needed to create a Photo.
     */
    data: XOR<PhotoCreateInput, PhotoUncheckedCreateInput>
  }

  /**
   * Photo createMany
   */
  export type PhotoCreateManyArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * The data used to create many Photos.
     */
    data: PhotoCreateManyInput | PhotoCreateManyInput[]
    skipDuplicates?: boolean
  }

  /**
   * Photo update
   */
  export type PhotoUpdateArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the Photo
     */
    select?: PhotoSelect<ExtArgs> | null
    /**
     * Omit specific fields from the Photo
     */
    omit?: PhotoOmit<ExtArgs> | null
    /**
     * Choose, which related nodes to fetch as well
     */
    include?: PhotoInclude<ExtArgs> | null
    /**
     * The data needed to update a Photo.
     */
    data: XOR<PhotoUpdateInput, PhotoUncheckedUpdateInput>
    /**
     * Choose, which Photo to update.
     */
    where: PhotoWhereUniqueInput
  }

  /**
   * Photo updateMany
   */
  export type PhotoUpdateManyArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * The data used to update Photos.
     */
    data: XOR<PhotoUpdateManyMutationInput, PhotoUncheckedUpdateManyInput>
    /**
     * Filter which Photos to update
     */
    where?: PhotoWhereInput
    /**
     * Limit how many Photos to update.
     */
    limit?: number
  }

  /**
   * Photo upsert
   */
  export type PhotoUpsertArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the Photo
     */
    select?: PhotoSelect<ExtArgs> | null
    /**
     * Omit specific fields from the Photo
     */
    omit?: PhotoOmit<ExtArgs> | null
    /**
     * Choose, which related nodes to fetch as well
     */
    include?: PhotoInclude<ExtArgs> | null
    /**
     * The filter to search for the Photo to update in case it exists.
     */
    where: PhotoWhereUniqueInput
    /**
     * In case the Photo found by the `where` argument doesn't exist, create a new Photo with this data.
     */
    create: XOR<PhotoCreateInput, PhotoUncheckedCreateInput>
    /**
     * In case the Photo was found with the provided `where` argument, update it with this data.
     */
    update: XOR<PhotoUpdateInput, PhotoUncheckedUpdateInput>
  }

  /**
   * Photo delete
   */
  export type PhotoDeleteArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the Photo
     */
    select?: PhotoSelect<ExtArgs> | null
    /**
     * Omit specific fields from the Photo
     */
    omit?: PhotoOmit<ExtArgs> | null
    /**
     * Choose, which related nodes to fetch as well
     */
    include?: PhotoInclude<ExtArgs> | null
    /**
     * Filter which Photo to delete.
     */
    where: PhotoWhereUniqueInput
  }

  /**
   * Photo deleteMany
   */
  export type PhotoDeleteManyArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Filter which Photos to delete
     */
    where?: PhotoWhereInput
    /**
     * Limit how many Photos to delete.
     */
    limit?: number
  }

  /**
   * Photo.faces
   */
  export type Photo$facesArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the Face
     */
    select?: FaceSelect<ExtArgs> | null
    /**
     * Omit specific fields from the Face
     */
    omit?: FaceOmit<ExtArgs> | null
    /**
     * Choose, which related nodes to fetch as well
     */
    include?: FaceInclude<ExtArgs> | null
    where?: FaceWhereInput
    orderBy?: FaceOrderByWithRelationInput | FaceOrderByWithRelationInput[]
    cursor?: FaceWhereUniqueInput
    take?: number
    skip?: number
    distinct?: FaceScalarFieldEnum | FaceScalarFieldEnum[]
  }

  /**
   * Photo without action
   */
  export type PhotoDefaultArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the Photo
     */
    select?: PhotoSelect<ExtArgs> | null
    /**
     * Omit specific fields from the Photo
     */
    omit?: PhotoOmit<ExtArgs> | null
    /**
     * Choose, which related nodes to fetch as well
     */
    include?: PhotoInclude<ExtArgs> | null
  }


  /**
   * Model Face
   */

  export type AggregateFace = {
    _count: FaceCountAggregateOutputType | null
    _avg: FaceAvgAggregateOutputType | null
    _sum: FaceSumAggregateOutputType | null
    _min: FaceMinAggregateOutputType | null
    _max: FaceMaxAggregateOutputType | null
  }

  export type FaceAvgAggregateOutputType = {
    id: number | null
    photoId: number | null
    groupId: number | null
  }

  export type FaceSumAggregateOutputType = {
    id: number | null
    photoId: number | null
    groupId: number | null
  }

  export type FaceMinAggregateOutputType = {
    id: number | null
    photoId: number | null
    groupId: number | null
    createdAt: Date | null
  }

  export type FaceMaxAggregateOutputType = {
    id: number | null
    photoId: number | null
    groupId: number | null
    createdAt: Date | null
  }

  export type FaceCountAggregateOutputType = {
    id: number
    photoId: number
    groupId: number
    vector: number
    createdAt: number
    _all: number
  }


  export type FaceAvgAggregateInputType = {
    id?: true
    photoId?: true
    groupId?: true
  }

  export type FaceSumAggregateInputType = {
    id?: true
    photoId?: true
    groupId?: true
  }

  export type FaceMinAggregateInputType = {
    id?: true
    photoId?: true
    groupId?: true
    createdAt?: true
  }

  export type FaceMaxAggregateInputType = {
    id?: true
    photoId?: true
    groupId?: true
    createdAt?: true
  }

  export type FaceCountAggregateInputType = {
    id?: true
    photoId?: true
    groupId?: true
    vector?: true
    createdAt?: true
    _all?: true
  }

  export type FaceAggregateArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Filter which Face to aggregate.
     */
    where?: FaceWhereInput
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/sorting Sorting Docs}
     * 
     * Determine the order of Faces to fetch.
     */
    orderBy?: FaceOrderByWithRelationInput | FaceOrderByWithRelationInput[]
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination#cursor-based-pagination Cursor Docs}
     * 
     * Sets the start position
     */
    cursor?: FaceWhereUniqueInput
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination Pagination Docs}
     * 
     * Take `±n` Faces from the position of the cursor.
     */
    take?: number
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination Pagination Docs}
     * 
     * Skip the first `n` Faces.
     */
    skip?: number
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/aggregations Aggregation Docs}
     * 
     * Count returned Faces
    **/
    _count?: true | FaceCountAggregateInputType
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/aggregations Aggregation Docs}
     * 
     * Select which fields to average
    **/
    _avg?: FaceAvgAggregateInputType
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/aggregations Aggregation Docs}
     * 
     * Select which fields to sum
    **/
    _sum?: FaceSumAggregateInputType
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/aggregations Aggregation Docs}
     * 
     * Select which fields to find the minimum value
    **/
    _min?: FaceMinAggregateInputType
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/aggregations Aggregation Docs}
     * 
     * Select which fields to find the maximum value
    **/
    _max?: FaceMaxAggregateInputType
  }

  export type GetFaceAggregateType<T extends FaceAggregateArgs> = {
        [P in keyof T & keyof AggregateFace]: P extends '_count' | 'count'
      ? T[P] extends true
        ? number
        : GetScalarType<T[P], AggregateFace[P]>
      : GetScalarType<T[P], AggregateFace[P]>
  }




  export type FaceGroupByArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    where?: FaceWhereInput
    orderBy?: FaceOrderByWithAggregationInput | FaceOrderByWithAggregationInput[]
    by: FaceScalarFieldEnum[] | FaceScalarFieldEnum
    having?: FaceScalarWhereWithAggregatesInput
    take?: number
    skip?: number
    _count?: FaceCountAggregateInputType | true
    _avg?: FaceAvgAggregateInputType
    _sum?: FaceSumAggregateInputType
    _min?: FaceMinAggregateInputType
    _max?: FaceMaxAggregateInputType
  }

  export type FaceGroupByOutputType = {
    id: number
    photoId: number
    groupId: number | null
    vector: JsonValue
    createdAt: Date
    _count: FaceCountAggregateOutputType | null
    _avg: FaceAvgAggregateOutputType | null
    _sum: FaceSumAggregateOutputType | null
    _min: FaceMinAggregateOutputType | null
    _max: FaceMaxAggregateOutputType | null
  }

  type GetFaceGroupByPayload<T extends FaceGroupByArgs> = Prisma.PrismaPromise<
    Array<
      PickEnumerable<FaceGroupByOutputType, T['by']> &
        {
          [P in ((keyof T) & (keyof FaceGroupByOutputType))]: P extends '_count'
            ? T[P] extends boolean
              ? number
              : GetScalarType<T[P], FaceGroupByOutputType[P]>
            : GetScalarType<T[P], FaceGroupByOutputType[P]>
        }
      >
    >


  export type FaceSelect<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = $Extensions.GetSelect<{
    id?: boolean
    photoId?: boolean
    groupId?: boolean
    vector?: boolean
    createdAt?: boolean
    photo?: boolean | PhotoDefaultArgs<ExtArgs>
    group?: boolean | Face$groupArgs<ExtArgs>
  }, ExtArgs["result"]["face"]>



  export type FaceSelectScalar = {
    id?: boolean
    photoId?: boolean
    groupId?: boolean
    vector?: boolean
    createdAt?: boolean
  }

  export type FaceOmit<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = $Extensions.GetOmit<"id" | "photoId" | "groupId" | "vector" | "createdAt", ExtArgs["result"]["face"]>
  export type FaceInclude<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    photo?: boolean | PhotoDefaultArgs<ExtArgs>
    group?: boolean | Face$groupArgs<ExtArgs>
  }

  export type $FacePayload<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    name: "Face"
    objects: {
      photo: Prisma.$PhotoPayload<ExtArgs>
      group: Prisma.$GroupPayload<ExtArgs> | null
    }
    scalars: $Extensions.GetPayloadResult<{
      id: number
      photoId: number
      groupId: number | null
      vector: Prisma.JsonValue
      createdAt: Date
    }, ExtArgs["result"]["face"]>
    composites: {}
  }

  type FaceGetPayload<S extends boolean | null | undefined | FaceDefaultArgs> = $Result.GetResult<Prisma.$FacePayload, S>

  type FaceCountArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> =
    Omit<FaceFindManyArgs, 'select' | 'include' | 'distinct' | 'omit'> & {
      select?: FaceCountAggregateInputType | true
    }

  export interface FaceDelegate<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs, GlobalOmitOptions = {}> {
    [K: symbol]: { types: Prisma.TypeMap<ExtArgs>['model']['Face'], meta: { name: 'Face' } }
    /**
     * Find zero or one Face that matches the filter.
     * @param {FaceFindUniqueArgs} args - Arguments to find a Face
     * @example
     * // Get one Face
     * const face = await prisma.face.findUnique({
     *   where: {
     *     // ... provide filter here
     *   }
     * })
     */
    findUnique<T extends FaceFindUniqueArgs>(args: SelectSubset<T, FaceFindUniqueArgs<ExtArgs>>): Prisma__FaceClient<$Result.GetResult<Prisma.$FacePayload<ExtArgs>, T, "findUnique", GlobalOmitOptions> | null, null, ExtArgs, GlobalOmitOptions>

    /**
     * Find one Face that matches the filter or throw an error with `error.code='P2025'`
     * if no matches were found.
     * @param {FaceFindUniqueOrThrowArgs} args - Arguments to find a Face
     * @example
     * // Get one Face
     * const face = await prisma.face.findUniqueOrThrow({
     *   where: {
     *     // ... provide filter here
     *   }
     * })
     */
    findUniqueOrThrow<T extends FaceFindUniqueOrThrowArgs>(args: SelectSubset<T, FaceFindUniqueOrThrowArgs<ExtArgs>>): Prisma__FaceClient<$Result.GetResult<Prisma.$FacePayload<ExtArgs>, T, "findUniqueOrThrow", GlobalOmitOptions>, never, ExtArgs, GlobalOmitOptions>

    /**
     * Find the first Face that matches the filter.
     * Note, that providing `undefined` is treated as the value not being there.
     * Read more here: https://pris.ly/d/null-undefined
     * @param {FaceFindFirstArgs} args - Arguments to find a Face
     * @example
     * // Get one Face
     * const face = await prisma.face.findFirst({
     *   where: {
     *     // ... provide filter here
     *   }
     * })
     */
    findFirst<T extends FaceFindFirstArgs>(args?: SelectSubset<T, FaceFindFirstArgs<ExtArgs>>): Prisma__FaceClient<$Result.GetResult<Prisma.$FacePayload<ExtArgs>, T, "findFirst", GlobalOmitOptions> | null, null, ExtArgs, GlobalOmitOptions>

    /**
     * Find the first Face that matches the filter or
     * throw `PrismaKnownClientError` with `P2025` code if no matches were found.
     * Note, that providing `undefined` is treated as the value not being there.
     * Read more here: https://pris.ly/d/null-undefined
     * @param {FaceFindFirstOrThrowArgs} args - Arguments to find a Face
     * @example
     * // Get one Face
     * const face = await prisma.face.findFirstOrThrow({
     *   where: {
     *     // ... provide filter here
     *   }
     * })
     */
    findFirstOrThrow<T extends FaceFindFirstOrThrowArgs>(args?: SelectSubset<T, FaceFindFirstOrThrowArgs<ExtArgs>>): Prisma__FaceClient<$Result.GetResult<Prisma.$FacePayload<ExtArgs>, T, "findFirstOrThrow", GlobalOmitOptions>, never, ExtArgs, GlobalOmitOptions>

    /**
     * Find zero or more Faces that matches the filter.
     * Note, that providing `undefined` is treated as the value not being there.
     * Read more here: https://pris.ly/d/null-undefined
     * @param {FaceFindManyArgs} args - Arguments to filter and select certain fields only.
     * @example
     * // Get all Faces
     * const faces = await prisma.face.findMany()
     * 
     * // Get first 10 Faces
     * const faces = await prisma.face.findMany({ take: 10 })
     * 
     * // Only select the `id`
     * const faceWithIdOnly = await prisma.face.findMany({ select: { id: true } })
     * 
     */
    findMany<T extends FaceFindManyArgs>(args?: SelectSubset<T, FaceFindManyArgs<ExtArgs>>): Prisma.PrismaPromise<$Result.GetResult<Prisma.$FacePayload<ExtArgs>, T, "findMany", GlobalOmitOptions>>

    /**
     * Create a Face.
     * @param {FaceCreateArgs} args - Arguments to create a Face.
     * @example
     * // Create one Face
     * const Face = await prisma.face.create({
     *   data: {
     *     // ... data to create a Face
     *   }
     * })
     * 
     */
    create<T extends FaceCreateArgs>(args: SelectSubset<T, FaceCreateArgs<ExtArgs>>): Prisma__FaceClient<$Result.GetResult<Prisma.$FacePayload<ExtArgs>, T, "create", GlobalOmitOptions>, never, ExtArgs, GlobalOmitOptions>

    /**
     * Create many Faces.
     * @param {FaceCreateManyArgs} args - Arguments to create many Faces.
     * @example
     * // Create many Faces
     * const face = await prisma.face.createMany({
     *   data: [
     *     // ... provide data here
     *   ]
     * })
     *     
     */
    createMany<T extends FaceCreateManyArgs>(args?: SelectSubset<T, FaceCreateManyArgs<ExtArgs>>): Prisma.PrismaPromise<BatchPayload>

    /**
     * Delete a Face.
     * @param {FaceDeleteArgs} args - Arguments to delete one Face.
     * @example
     * // Delete one Face
     * const Face = await prisma.face.delete({
     *   where: {
     *     // ... filter to delete one Face
     *   }
     * })
     * 
     */
    delete<T extends FaceDeleteArgs>(args: SelectSubset<T, FaceDeleteArgs<ExtArgs>>): Prisma__FaceClient<$Result.GetResult<Prisma.$FacePayload<ExtArgs>, T, "delete", GlobalOmitOptions>, never, ExtArgs, GlobalOmitOptions>

    /**
     * Update one Face.
     * @param {FaceUpdateArgs} args - Arguments to update one Face.
     * @example
     * // Update one Face
     * const face = await prisma.face.update({
     *   where: {
     *     // ... provide filter here
     *   },
     *   data: {
     *     // ... provide data here
     *   }
     * })
     * 
     */
    update<T extends FaceUpdateArgs>(args: SelectSubset<T, FaceUpdateArgs<ExtArgs>>): Prisma__FaceClient<$Result.GetResult<Prisma.$FacePayload<ExtArgs>, T, "update", GlobalOmitOptions>, never, ExtArgs, GlobalOmitOptions>

    /**
     * Delete zero or more Faces.
     * @param {FaceDeleteManyArgs} args - Arguments to filter Faces to delete.
     * @example
     * // Delete a few Faces
     * const { count } = await prisma.face.deleteMany({
     *   where: {
     *     // ... provide filter here
     *   }
     * })
     * 
     */
    deleteMany<T extends FaceDeleteManyArgs>(args?: SelectSubset<T, FaceDeleteManyArgs<ExtArgs>>): Prisma.PrismaPromise<BatchPayload>

    /**
     * Update zero or more Faces.
     * Note, that providing `undefined` is treated as the value not being there.
     * Read more here: https://pris.ly/d/null-undefined
     * @param {FaceUpdateManyArgs} args - Arguments to update one or more rows.
     * @example
     * // Update many Faces
     * const face = await prisma.face.updateMany({
     *   where: {
     *     // ... provide filter here
     *   },
     *   data: {
     *     // ... provide data here
     *   }
     * })
     * 
     */
    updateMany<T extends FaceUpdateManyArgs>(args: SelectSubset<T, FaceUpdateManyArgs<ExtArgs>>): Prisma.PrismaPromise<BatchPayload>

    /**
     * Create or update one Face.
     * @param {FaceUpsertArgs} args - Arguments to update or create a Face.
     * @example
     * // Update or create a Face
     * const face = await prisma.face.upsert({
     *   create: {
     *     // ... data to create a Face
     *   },
     *   update: {
     *     // ... in case it already exists, update
     *   },
     *   where: {
     *     // ... the filter for the Face we want to update
     *   }
     * })
     */
    upsert<T extends FaceUpsertArgs>(args: SelectSubset<T, FaceUpsertArgs<ExtArgs>>): Prisma__FaceClient<$Result.GetResult<Prisma.$FacePayload<ExtArgs>, T, "upsert", GlobalOmitOptions>, never, ExtArgs, GlobalOmitOptions>


    /**
     * Count the number of Faces.
     * Note, that providing `undefined` is treated as the value not being there.
     * Read more here: https://pris.ly/d/null-undefined
     * @param {FaceCountArgs} args - Arguments to filter Faces to count.
     * @example
     * // Count the number of Faces
     * const count = await prisma.face.count({
     *   where: {
     *     // ... the filter for the Faces we want to count
     *   }
     * })
    **/
    count<T extends FaceCountArgs>(
      args?: Subset<T, FaceCountArgs>,
    ): Prisma.PrismaPromise<
      T extends $Utils.Record<'select', any>
        ? T['select'] extends true
          ? number
          : GetScalarType<T['select'], FaceCountAggregateOutputType>
        : number
    >

    /**
     * Allows you to perform aggregations operations on a Face.
     * Note, that providing `undefined` is treated as the value not being there.
     * Read more here: https://pris.ly/d/null-undefined
     * @param {FaceAggregateArgs} args - Select which aggregations you would like to apply and on what fields.
     * @example
     * // Ordered by age ascending
     * // Where email contains prisma.io
     * // Limited to the 10 users
     * const aggregations = await prisma.user.aggregate({
     *   _avg: {
     *     age: true,
     *   },
     *   where: {
     *     email: {
     *       contains: "prisma.io",
     *     },
     *   },
     *   orderBy: {
     *     age: "asc",
     *   },
     *   take: 10,
     * })
    **/
    aggregate<T extends FaceAggregateArgs>(args: Subset<T, FaceAggregateArgs>): Prisma.PrismaPromise<GetFaceAggregateType<T>>

    /**
     * Group by Face.
     * Note, that providing `undefined` is treated as the value not being there.
     * Read more here: https://pris.ly/d/null-undefined
     * @param {FaceGroupByArgs} args - Group by arguments.
     * @example
     * // Group by city, order by createdAt, get count
     * const result = await prisma.user.groupBy({
     *   by: ['city', 'createdAt'],
     *   orderBy: {
     *     createdAt: true
     *   },
     *   _count: {
     *     _all: true
     *   },
     * })
     * 
    **/
    groupBy<
      T extends FaceGroupByArgs,
      HasSelectOrTake extends Or<
        Extends<'skip', Keys<T>>,
        Extends<'take', Keys<T>>
      >,
      OrderByArg extends True extends HasSelectOrTake
        ? { orderBy: FaceGroupByArgs['orderBy'] }
        : { orderBy?: FaceGroupByArgs['orderBy'] },
      OrderFields extends ExcludeUnderscoreKeys<Keys<MaybeTupleToUnion<T['orderBy']>>>,
      ByFields extends MaybeTupleToUnion<T['by']>,
      ByValid extends Has<ByFields, OrderFields>,
      HavingFields extends GetHavingFields<T['having']>,
      HavingValid extends Has<ByFields, HavingFields>,
      ByEmpty extends T['by'] extends never[] ? True : False,
      InputErrors extends ByEmpty extends True
      ? `Error: "by" must not be empty.`
      : HavingValid extends False
      ? {
          [P in HavingFields]: P extends ByFields
            ? never
            : P extends string
            ? `Error: Field "${P}" used in "having" needs to be provided in "by".`
            : [
                Error,
                'Field ',
                P,
                ` in "having" needs to be provided in "by"`,
              ]
        }[HavingFields]
      : 'take' extends Keys<T>
      ? 'orderBy' extends Keys<T>
        ? ByValid extends True
          ? {}
          : {
              [P in OrderFields]: P extends ByFields
                ? never
                : `Error: Field "${P}" in "orderBy" needs to be provided in "by"`
            }[OrderFields]
        : 'Error: If you provide "take", you also need to provide "orderBy"'
      : 'skip' extends Keys<T>
      ? 'orderBy' extends Keys<T>
        ? ByValid extends True
          ? {}
          : {
              [P in OrderFields]: P extends ByFields
                ? never
                : `Error: Field "${P}" in "orderBy" needs to be provided in "by"`
            }[OrderFields]
        : 'Error: If you provide "skip", you also need to provide "orderBy"'
      : ByValid extends True
      ? {}
      : {
          [P in OrderFields]: P extends ByFields
            ? never
            : `Error: Field "${P}" in "orderBy" needs to be provided in "by"`
        }[OrderFields]
    >(args: SubsetIntersection<T, FaceGroupByArgs, OrderByArg> & InputErrors): {} extends InputErrors ? GetFaceGroupByPayload<T> : Prisma.PrismaPromise<InputErrors>
  /**
   * Fields of the Face model
   */
  readonly fields: FaceFieldRefs;
  }

  /**
   * The delegate class that acts as a "Promise-like" for Face.
   * Why is this prefixed with `Prisma__`?
   * Because we want to prevent naming conflicts as mentioned in
   * https://github.com/prisma/prisma-client-js/issues/707
   */
  export interface Prisma__FaceClient<T, Null = never, ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs, GlobalOmitOptions = {}> extends Prisma.PrismaPromise<T> {
    readonly [Symbol.toStringTag]: "PrismaPromise"
    photo<T extends PhotoDefaultArgs<ExtArgs> = {}>(args?: Subset<T, PhotoDefaultArgs<ExtArgs>>): Prisma__PhotoClient<$Result.GetResult<Prisma.$PhotoPayload<ExtArgs>, T, "findUniqueOrThrow", GlobalOmitOptions> | Null, Null, ExtArgs, GlobalOmitOptions>
    group<T extends Face$groupArgs<ExtArgs> = {}>(args?: Subset<T, Face$groupArgs<ExtArgs>>): Prisma__GroupClient<$Result.GetResult<Prisma.$GroupPayload<ExtArgs>, T, "findUniqueOrThrow", GlobalOmitOptions> | null, null, ExtArgs, GlobalOmitOptions>
    /**
     * Attaches callbacks for the resolution and/or rejection of the Promise.
     * @param onfulfilled The callback to execute when the Promise is resolved.
     * @param onrejected The callback to execute when the Promise is rejected.
     * @returns A Promise for the completion of which ever callback is executed.
     */
    then<TResult1 = T, TResult2 = never>(onfulfilled?: ((value: T) => TResult1 | PromiseLike<TResult1>) | undefined | null, onrejected?: ((reason: any) => TResult2 | PromiseLike<TResult2>) | undefined | null): $Utils.JsPromise<TResult1 | TResult2>
    /**
     * Attaches a callback for only the rejection of the Promise.
     * @param onrejected The callback to execute when the Promise is rejected.
     * @returns A Promise for the completion of the callback.
     */
    catch<TResult = never>(onrejected?: ((reason: any) => TResult | PromiseLike<TResult>) | undefined | null): $Utils.JsPromise<T | TResult>
    /**
     * Attaches a callback that is invoked when the Promise is settled (fulfilled or rejected). The
     * resolved value cannot be modified from the callback.
     * @param onfinally The callback to execute when the Promise is settled (fulfilled or rejected).
     * @returns A Promise for the completion of the callback.
     */
    finally(onfinally?: (() => void) | undefined | null): $Utils.JsPromise<T>
  }




  /**
   * Fields of the Face model
   */
  interface FaceFieldRefs {
    readonly id: FieldRef<"Face", 'Int'>
    readonly photoId: FieldRef<"Face", 'Int'>
    readonly groupId: FieldRef<"Face", 'Int'>
    readonly vector: FieldRef<"Face", 'Json'>
    readonly createdAt: FieldRef<"Face", 'DateTime'>
  }
    

  // Custom InputTypes
  /**
   * Face findUnique
   */
  export type FaceFindUniqueArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the Face
     */
    select?: FaceSelect<ExtArgs> | null
    /**
     * Omit specific fields from the Face
     */
    omit?: FaceOmit<ExtArgs> | null
    /**
     * Choose, which related nodes to fetch as well
     */
    include?: FaceInclude<ExtArgs> | null
    /**
     * Filter, which Face to fetch.
     */
    where: FaceWhereUniqueInput
  }

  /**
   * Face findUniqueOrThrow
   */
  export type FaceFindUniqueOrThrowArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the Face
     */
    select?: FaceSelect<ExtArgs> | null
    /**
     * Omit specific fields from the Face
     */
    omit?: FaceOmit<ExtArgs> | null
    /**
     * Choose, which related nodes to fetch as well
     */
    include?: FaceInclude<ExtArgs> | null
    /**
     * Filter, which Face to fetch.
     */
    where: FaceWhereUniqueInput
  }

  /**
   * Face findFirst
   */
  export type FaceFindFirstArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the Face
     */
    select?: FaceSelect<ExtArgs> | null
    /**
     * Omit specific fields from the Face
     */
    omit?: FaceOmit<ExtArgs> | null
    /**
     * Choose, which related nodes to fetch as well
     */
    include?: FaceInclude<ExtArgs> | null
    /**
     * Filter, which Face to fetch.
     */
    where?: FaceWhereInput
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/sorting Sorting Docs}
     * 
     * Determine the order of Faces to fetch.
     */
    orderBy?: FaceOrderByWithRelationInput | FaceOrderByWithRelationInput[]
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination#cursor-based-pagination Cursor Docs}
     * 
     * Sets the position for searching for Faces.
     */
    cursor?: FaceWhereUniqueInput
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination Pagination Docs}
     * 
     * Take `±n` Faces from the position of the cursor.
     */
    take?: number
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination Pagination Docs}
     * 
     * Skip the first `n` Faces.
     */
    skip?: number
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/distinct Distinct Docs}
     * 
     * Filter by unique combinations of Faces.
     */
    distinct?: FaceScalarFieldEnum | FaceScalarFieldEnum[]
  }

  /**
   * Face findFirstOrThrow
   */
  export type FaceFindFirstOrThrowArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the Face
     */
    select?: FaceSelect<ExtArgs> | null
    /**
     * Omit specific fields from the Face
     */
    omit?: FaceOmit<ExtArgs> | null
    /**
     * Choose, which related nodes to fetch as well
     */
    include?: FaceInclude<ExtArgs> | null
    /**
     * Filter, which Face to fetch.
     */
    where?: FaceWhereInput
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/sorting Sorting Docs}
     * 
     * Determine the order of Faces to fetch.
     */
    orderBy?: FaceOrderByWithRelationInput | FaceOrderByWithRelationInput[]
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination#cursor-based-pagination Cursor Docs}
     * 
     * Sets the position for searching for Faces.
     */
    cursor?: FaceWhereUniqueInput
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination Pagination Docs}
     * 
     * Take `±n` Faces from the position of the cursor.
     */
    take?: number
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination Pagination Docs}
     * 
     * Skip the first `n` Faces.
     */
    skip?: number
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/distinct Distinct Docs}
     * 
     * Filter by unique combinations of Faces.
     */
    distinct?: FaceScalarFieldEnum | FaceScalarFieldEnum[]
  }

  /**
   * Face findMany
   */
  export type FaceFindManyArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the Face
     */
    select?: FaceSelect<ExtArgs> | null
    /**
     * Omit specific fields from the Face
     */
    omit?: FaceOmit<ExtArgs> | null
    /**
     * Choose, which related nodes to fetch as well
     */
    include?: FaceInclude<ExtArgs> | null
    /**
     * Filter, which Faces to fetch.
     */
    where?: FaceWhereInput
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/sorting Sorting Docs}
     * 
     * Determine the order of Faces to fetch.
     */
    orderBy?: FaceOrderByWithRelationInput | FaceOrderByWithRelationInput[]
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination#cursor-based-pagination Cursor Docs}
     * 
     * Sets the position for listing Faces.
     */
    cursor?: FaceWhereUniqueInput
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination Pagination Docs}
     * 
     * Take `±n` Faces from the position of the cursor.
     */
    take?: number
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination Pagination Docs}
     * 
     * Skip the first `n` Faces.
     */
    skip?: number
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/distinct Distinct Docs}
     * 
     * Filter by unique combinations of Faces.
     */
    distinct?: FaceScalarFieldEnum | FaceScalarFieldEnum[]
  }

  /**
   * Face create
   */
  export type FaceCreateArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the Face
     */
    select?: FaceSelect<ExtArgs> | null
    /**
     * Omit specific fields from the Face
     */
    omit?: FaceOmit<ExtArgs> | null
    /**
     * Choose, which related nodes to fetch as well
     */
    include?: FaceInclude<ExtArgs> | null
    /**
     * The data needed to create a Face.
     */
    data: XOR<FaceCreateInput, FaceUncheckedCreateInput>
  }

  /**
   * Face createMany
   */
  export type FaceCreateManyArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * The data used to create many Faces.
     */
    data: FaceCreateManyInput | FaceCreateManyInput[]
    skipDuplicates?: boolean
  }

  /**
   * Face update
   */
  export type FaceUpdateArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the Face
     */
    select?: FaceSelect<ExtArgs> | null
    /**
     * Omit specific fields from the Face
     */
    omit?: FaceOmit<ExtArgs> | null
    /**
     * Choose, which related nodes to fetch as well
     */
    include?: FaceInclude<ExtArgs> | null
    /**
     * The data needed to update a Face.
     */
    data: XOR<FaceUpdateInput, FaceUncheckedUpdateInput>
    /**
     * Choose, which Face to update.
     */
    where: FaceWhereUniqueInput
  }

  /**
   * Face updateMany
   */
  export type FaceUpdateManyArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * The data used to update Faces.
     */
    data: XOR<FaceUpdateManyMutationInput, FaceUncheckedUpdateManyInput>
    /**
     * Filter which Faces to update
     */
    where?: FaceWhereInput
    /**
     * Limit how many Faces to update.
     */
    limit?: number
  }

  /**
   * Face upsert
   */
  export type FaceUpsertArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the Face
     */
    select?: FaceSelect<ExtArgs> | null
    /**
     * Omit specific fields from the Face
     */
    omit?: FaceOmit<ExtArgs> | null
    /**
     * Choose, which related nodes to fetch as well
     */
    include?: FaceInclude<ExtArgs> | null
    /**
     * The filter to search for the Face to update in case it exists.
     */
    where: FaceWhereUniqueInput
    /**
     * In case the Face found by the `where` argument doesn't exist, create a new Face with this data.
     */
    create: XOR<FaceCreateInput, FaceUncheckedCreateInput>
    /**
     * In case the Face was found with the provided `where` argument, update it with this data.
     */
    update: XOR<FaceUpdateInput, FaceUncheckedUpdateInput>
  }

  /**
   * Face delete
   */
  export type FaceDeleteArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the Face
     */
    select?: FaceSelect<ExtArgs> | null
    /**
     * Omit specific fields from the Face
     */
    omit?: FaceOmit<ExtArgs> | null
    /**
     * Choose, which related nodes to fetch as well
     */
    include?: FaceInclude<ExtArgs> | null
    /**
     * Filter which Face to delete.
     */
    where: FaceWhereUniqueInput
  }

  /**
   * Face deleteMany
   */
  export type FaceDeleteManyArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Filter which Faces to delete
     */
    where?: FaceWhereInput
    /**
     * Limit how many Faces to delete.
     */
    limit?: number
  }

  /**
   * Face.group
   */
  export type Face$groupArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the Group
     */
    select?: GroupSelect<ExtArgs> | null
    /**
     * Omit specific fields from the Group
     */
    omit?: GroupOmit<ExtArgs> | null
    /**
     * Choose, which related nodes to fetch as well
     */
    include?: GroupInclude<ExtArgs> | null
    where?: GroupWhereInput
  }

  /**
   * Face without action
   */
  export type FaceDefaultArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the Face
     */
    select?: FaceSelect<ExtArgs> | null
    /**
     * Omit specific fields from the Face
     */
    omit?: FaceOmit<ExtArgs> | null
    /**
     * Choose, which related nodes to fetch as well
     */
    include?: FaceInclude<ExtArgs> | null
  }


  /**
   * Model Group
   */

  export type AggregateGroup = {
    _count: GroupCountAggregateOutputType | null
    _avg: GroupAvgAggregateOutputType | null
    _sum: GroupSumAggregateOutputType | null
    _min: GroupMinAggregateOutputType | null
    _max: GroupMaxAggregateOutputType | null
  }

  export type GroupAvgAggregateOutputType = {
    id: number | null
    appInstanceId: number | null
  }

  export type GroupSumAggregateOutputType = {
    id: number | null
    appInstanceId: number | null
  }

  export type GroupMinAggregateOutputType = {
    id: number | null
    appInstanceId: number | null
    name: string | null
    createdAt: Date | null
  }

  export type GroupMaxAggregateOutputType = {
    id: number | null
    appInstanceId: number | null
    name: string | null
    createdAt: Date | null
  }

  export type GroupCountAggregateOutputType = {
    id: number
    appInstanceId: number
    name: number
    createdAt: number
    _all: number
  }


  export type GroupAvgAggregateInputType = {
    id?: true
    appInstanceId?: true
  }

  export type GroupSumAggregateInputType = {
    id?: true
    appInstanceId?: true
  }

  export type GroupMinAggregateInputType = {
    id?: true
    appInstanceId?: true
    name?: true
    createdAt?: true
  }

  export type GroupMaxAggregateInputType = {
    id?: true
    appInstanceId?: true
    name?: true
    createdAt?: true
  }

  export type GroupCountAggregateInputType = {
    id?: true
    appInstanceId?: true
    name?: true
    createdAt?: true
    _all?: true
  }

  export type GroupAggregateArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Filter which Group to aggregate.
     */
    where?: GroupWhereInput
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/sorting Sorting Docs}
     * 
     * Determine the order of Groups to fetch.
     */
    orderBy?: GroupOrderByWithRelationInput | GroupOrderByWithRelationInput[]
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination#cursor-based-pagination Cursor Docs}
     * 
     * Sets the start position
     */
    cursor?: GroupWhereUniqueInput
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination Pagination Docs}
     * 
     * Take `±n` Groups from the position of the cursor.
     */
    take?: number
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination Pagination Docs}
     * 
     * Skip the first `n` Groups.
     */
    skip?: number
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/aggregations Aggregation Docs}
     * 
     * Count returned Groups
    **/
    _count?: true | GroupCountAggregateInputType
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/aggregations Aggregation Docs}
     * 
     * Select which fields to average
    **/
    _avg?: GroupAvgAggregateInputType
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/aggregations Aggregation Docs}
     * 
     * Select which fields to sum
    **/
    _sum?: GroupSumAggregateInputType
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/aggregations Aggregation Docs}
     * 
     * Select which fields to find the minimum value
    **/
    _min?: GroupMinAggregateInputType
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/aggregations Aggregation Docs}
     * 
     * Select which fields to find the maximum value
    **/
    _max?: GroupMaxAggregateInputType
  }

  export type GetGroupAggregateType<T extends GroupAggregateArgs> = {
        [P in keyof T & keyof AggregateGroup]: P extends '_count' | 'count'
      ? T[P] extends true
        ? number
        : GetScalarType<T[P], AggregateGroup[P]>
      : GetScalarType<T[P], AggregateGroup[P]>
  }




  export type GroupGroupByArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    where?: GroupWhereInput
    orderBy?: GroupOrderByWithAggregationInput | GroupOrderByWithAggregationInput[]
    by: GroupScalarFieldEnum[] | GroupScalarFieldEnum
    having?: GroupScalarWhereWithAggregatesInput
    take?: number
    skip?: number
    _count?: GroupCountAggregateInputType | true
    _avg?: GroupAvgAggregateInputType
    _sum?: GroupSumAggregateInputType
    _min?: GroupMinAggregateInputType
    _max?: GroupMaxAggregateInputType
  }

  export type GroupGroupByOutputType = {
    id: number
    appInstanceId: number
    name: string
    createdAt: Date
    _count: GroupCountAggregateOutputType | null
    _avg: GroupAvgAggregateOutputType | null
    _sum: GroupSumAggregateOutputType | null
    _min: GroupMinAggregateOutputType | null
    _max: GroupMaxAggregateOutputType | null
  }

  type GetGroupGroupByPayload<T extends GroupGroupByArgs> = Prisma.PrismaPromise<
    Array<
      PickEnumerable<GroupGroupByOutputType, T['by']> &
        {
          [P in ((keyof T) & (keyof GroupGroupByOutputType))]: P extends '_count'
            ? T[P] extends boolean
              ? number
              : GetScalarType<T[P], GroupGroupByOutputType[P]>
            : GetScalarType<T[P], GroupGroupByOutputType[P]>
        }
      >
    >


  export type GroupSelect<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = $Extensions.GetSelect<{
    id?: boolean
    appInstanceId?: boolean
    name?: boolean
    createdAt?: boolean
    appInstance?: boolean | AppInstanceDefaultArgs<ExtArgs>
    faces?: boolean | Group$facesArgs<ExtArgs>
    _count?: boolean | GroupCountOutputTypeDefaultArgs<ExtArgs>
  }, ExtArgs["result"]["group"]>



  export type GroupSelectScalar = {
    id?: boolean
    appInstanceId?: boolean
    name?: boolean
    createdAt?: boolean
  }

  export type GroupOmit<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = $Extensions.GetOmit<"id" | "appInstanceId" | "name" | "createdAt", ExtArgs["result"]["group"]>
  export type GroupInclude<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    appInstance?: boolean | AppInstanceDefaultArgs<ExtArgs>
    faces?: boolean | Group$facesArgs<ExtArgs>
    _count?: boolean | GroupCountOutputTypeDefaultArgs<ExtArgs>
  }

  export type $GroupPayload<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    name: "Group"
    objects: {
      appInstance: Prisma.$AppInstancePayload<ExtArgs>
      faces: Prisma.$FacePayload<ExtArgs>[]
    }
    scalars: $Extensions.GetPayloadResult<{
      id: number
      appInstanceId: number
      name: string
      createdAt: Date
    }, ExtArgs["result"]["group"]>
    composites: {}
  }

  type GroupGetPayload<S extends boolean | null | undefined | GroupDefaultArgs> = $Result.GetResult<Prisma.$GroupPayload, S>

  type GroupCountArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> =
    Omit<GroupFindManyArgs, 'select' | 'include' | 'distinct' | 'omit'> & {
      select?: GroupCountAggregateInputType | true
    }

  export interface GroupDelegate<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs, GlobalOmitOptions = {}> {
    [K: symbol]: { types: Prisma.TypeMap<ExtArgs>['model']['Group'], meta: { name: 'Group' } }
    /**
     * Find zero or one Group that matches the filter.
     * @param {GroupFindUniqueArgs} args - Arguments to find a Group
     * @example
     * // Get one Group
     * const group = await prisma.group.findUnique({
     *   where: {
     *     // ... provide filter here
     *   }
     * })
     */
    findUnique<T extends GroupFindUniqueArgs>(args: SelectSubset<T, GroupFindUniqueArgs<ExtArgs>>): Prisma__GroupClient<$Result.GetResult<Prisma.$GroupPayload<ExtArgs>, T, "findUnique", GlobalOmitOptions> | null, null, ExtArgs, GlobalOmitOptions>

    /**
     * Find one Group that matches the filter or throw an error with `error.code='P2025'`
     * if no matches were found.
     * @param {GroupFindUniqueOrThrowArgs} args - Arguments to find a Group
     * @example
     * // Get one Group
     * const group = await prisma.group.findUniqueOrThrow({
     *   where: {
     *     // ... provide filter here
     *   }
     * })
     */
    findUniqueOrThrow<T extends GroupFindUniqueOrThrowArgs>(args: SelectSubset<T, GroupFindUniqueOrThrowArgs<ExtArgs>>): Prisma__GroupClient<$Result.GetResult<Prisma.$GroupPayload<ExtArgs>, T, "findUniqueOrThrow", GlobalOmitOptions>, never, ExtArgs, GlobalOmitOptions>

    /**
     * Find the first Group that matches the filter.
     * Note, that providing `undefined` is treated as the value not being there.
     * Read more here: https://pris.ly/d/null-undefined
     * @param {GroupFindFirstArgs} args - Arguments to find a Group
     * @example
     * // Get one Group
     * const group = await prisma.group.findFirst({
     *   where: {
     *     // ... provide filter here
     *   }
     * })
     */
    findFirst<T extends GroupFindFirstArgs>(args?: SelectSubset<T, GroupFindFirstArgs<ExtArgs>>): Prisma__GroupClient<$Result.GetResult<Prisma.$GroupPayload<ExtArgs>, T, "findFirst", GlobalOmitOptions> | null, null, ExtArgs, GlobalOmitOptions>

    /**
     * Find the first Group that matches the filter or
     * throw `PrismaKnownClientError` with `P2025` code if no matches were found.
     * Note, that providing `undefined` is treated as the value not being there.
     * Read more here: https://pris.ly/d/null-undefined
     * @param {GroupFindFirstOrThrowArgs} args - Arguments to find a Group
     * @example
     * // Get one Group
     * const group = await prisma.group.findFirstOrThrow({
     *   where: {
     *     // ... provide filter here
     *   }
     * })
     */
    findFirstOrThrow<T extends GroupFindFirstOrThrowArgs>(args?: SelectSubset<T, GroupFindFirstOrThrowArgs<ExtArgs>>): Prisma__GroupClient<$Result.GetResult<Prisma.$GroupPayload<ExtArgs>, T, "findFirstOrThrow", GlobalOmitOptions>, never, ExtArgs, GlobalOmitOptions>

    /**
     * Find zero or more Groups that matches the filter.
     * Note, that providing `undefined` is treated as the value not being there.
     * Read more here: https://pris.ly/d/null-undefined
     * @param {GroupFindManyArgs} args - Arguments to filter and select certain fields only.
     * @example
     * // Get all Groups
     * const groups = await prisma.group.findMany()
     * 
     * // Get first 10 Groups
     * const groups = await prisma.group.findMany({ take: 10 })
     * 
     * // Only select the `id`
     * const groupWithIdOnly = await prisma.group.findMany({ select: { id: true } })
     * 
     */
    findMany<T extends GroupFindManyArgs>(args?: SelectSubset<T, GroupFindManyArgs<ExtArgs>>): Prisma.PrismaPromise<$Result.GetResult<Prisma.$GroupPayload<ExtArgs>, T, "findMany", GlobalOmitOptions>>

    /**
     * Create a Group.
     * @param {GroupCreateArgs} args - Arguments to create a Group.
     * @example
     * // Create one Group
     * const Group = await prisma.group.create({
     *   data: {
     *     // ... data to create a Group
     *   }
     * })
     * 
     */
    create<T extends GroupCreateArgs>(args: SelectSubset<T, GroupCreateArgs<ExtArgs>>): Prisma__GroupClient<$Result.GetResult<Prisma.$GroupPayload<ExtArgs>, T, "create", GlobalOmitOptions>, never, ExtArgs, GlobalOmitOptions>

    /**
     * Create many Groups.
     * @param {GroupCreateManyArgs} args - Arguments to create many Groups.
     * @example
     * // Create many Groups
     * const group = await prisma.group.createMany({
     *   data: [
     *     // ... provide data here
     *   ]
     * })
     *     
     */
    createMany<T extends GroupCreateManyArgs>(args?: SelectSubset<T, GroupCreateManyArgs<ExtArgs>>): Prisma.PrismaPromise<BatchPayload>

    /**
     * Delete a Group.
     * @param {GroupDeleteArgs} args - Arguments to delete one Group.
     * @example
     * // Delete one Group
     * const Group = await prisma.group.delete({
     *   where: {
     *     // ... filter to delete one Group
     *   }
     * })
     * 
     */
    delete<T extends GroupDeleteArgs>(args: SelectSubset<T, GroupDeleteArgs<ExtArgs>>): Prisma__GroupClient<$Result.GetResult<Prisma.$GroupPayload<ExtArgs>, T, "delete", GlobalOmitOptions>, never, ExtArgs, GlobalOmitOptions>

    /**
     * Update one Group.
     * @param {GroupUpdateArgs} args - Arguments to update one Group.
     * @example
     * // Update one Group
     * const group = await prisma.group.update({
     *   where: {
     *     // ... provide filter here
     *   },
     *   data: {
     *     // ... provide data here
     *   }
     * })
     * 
     */
    update<T extends GroupUpdateArgs>(args: SelectSubset<T, GroupUpdateArgs<ExtArgs>>): Prisma__GroupClient<$Result.GetResult<Prisma.$GroupPayload<ExtArgs>, T, "update", GlobalOmitOptions>, never, ExtArgs, GlobalOmitOptions>

    /**
     * Delete zero or more Groups.
     * @param {GroupDeleteManyArgs} args - Arguments to filter Groups to delete.
     * @example
     * // Delete a few Groups
     * const { count } = await prisma.group.deleteMany({
     *   where: {
     *     // ... provide filter here
     *   }
     * })
     * 
     */
    deleteMany<T extends GroupDeleteManyArgs>(args?: SelectSubset<T, GroupDeleteManyArgs<ExtArgs>>): Prisma.PrismaPromise<BatchPayload>

    /**
     * Update zero or more Groups.
     * Note, that providing `undefined` is treated as the value not being there.
     * Read more here: https://pris.ly/d/null-undefined
     * @param {GroupUpdateManyArgs} args - Arguments to update one or more rows.
     * @example
     * // Update many Groups
     * const group = await prisma.group.updateMany({
     *   where: {
     *     // ... provide filter here
     *   },
     *   data: {
     *     // ... provide data here
     *   }
     * })
     * 
     */
    updateMany<T extends GroupUpdateManyArgs>(args: SelectSubset<T, GroupUpdateManyArgs<ExtArgs>>): Prisma.PrismaPromise<BatchPayload>

    /**
     * Create or update one Group.
     * @param {GroupUpsertArgs} args - Arguments to update or create a Group.
     * @example
     * // Update or create a Group
     * const group = await prisma.group.upsert({
     *   create: {
     *     // ... data to create a Group
     *   },
     *   update: {
     *     // ... in case it already exists, update
     *   },
     *   where: {
     *     // ... the filter for the Group we want to update
     *   }
     * })
     */
    upsert<T extends GroupUpsertArgs>(args: SelectSubset<T, GroupUpsertArgs<ExtArgs>>): Prisma__GroupClient<$Result.GetResult<Prisma.$GroupPayload<ExtArgs>, T, "upsert", GlobalOmitOptions>, never, ExtArgs, GlobalOmitOptions>


    /**
     * Count the number of Groups.
     * Note, that providing `undefined` is treated as the value not being there.
     * Read more here: https://pris.ly/d/null-undefined
     * @param {GroupCountArgs} args - Arguments to filter Groups to count.
     * @example
     * // Count the number of Groups
     * const count = await prisma.group.count({
     *   where: {
     *     // ... the filter for the Groups we want to count
     *   }
     * })
    **/
    count<T extends GroupCountArgs>(
      args?: Subset<T, GroupCountArgs>,
    ): Prisma.PrismaPromise<
      T extends $Utils.Record<'select', any>
        ? T['select'] extends true
          ? number
          : GetScalarType<T['select'], GroupCountAggregateOutputType>
        : number
    >

    /**
     * Allows you to perform aggregations operations on a Group.
     * Note, that providing `undefined` is treated as the value not being there.
     * Read more here: https://pris.ly/d/null-undefined
     * @param {GroupAggregateArgs} args - Select which aggregations you would like to apply and on what fields.
     * @example
     * // Ordered by age ascending
     * // Where email contains prisma.io
     * // Limited to the 10 users
     * const aggregations = await prisma.user.aggregate({
     *   _avg: {
     *     age: true,
     *   },
     *   where: {
     *     email: {
     *       contains: "prisma.io",
     *     },
     *   },
     *   orderBy: {
     *     age: "asc",
     *   },
     *   take: 10,
     * })
    **/
    aggregate<T extends GroupAggregateArgs>(args: Subset<T, GroupAggregateArgs>): Prisma.PrismaPromise<GetGroupAggregateType<T>>

    /**
     * Group by Group.
     * Note, that providing `undefined` is treated as the value not being there.
     * Read more here: https://pris.ly/d/null-undefined
     * @param {GroupGroupByArgs} args - Group by arguments.
     * @example
     * // Group by city, order by createdAt, get count
     * const result = await prisma.user.groupBy({
     *   by: ['city', 'createdAt'],
     *   orderBy: {
     *     createdAt: true
     *   },
     *   _count: {
     *     _all: true
     *   },
     * })
     * 
    **/
    groupBy<
      T extends GroupGroupByArgs,
      HasSelectOrTake extends Or<
        Extends<'skip', Keys<T>>,
        Extends<'take', Keys<T>>
      >,
      OrderByArg extends True extends HasSelectOrTake
        ? { orderBy: GroupGroupByArgs['orderBy'] }
        : { orderBy?: GroupGroupByArgs['orderBy'] },
      OrderFields extends ExcludeUnderscoreKeys<Keys<MaybeTupleToUnion<T['orderBy']>>>,
      ByFields extends MaybeTupleToUnion<T['by']>,
      ByValid extends Has<ByFields, OrderFields>,
      HavingFields extends GetHavingFields<T['having']>,
      HavingValid extends Has<ByFields, HavingFields>,
      ByEmpty extends T['by'] extends never[] ? True : False,
      InputErrors extends ByEmpty extends True
      ? `Error: "by" must not be empty.`
      : HavingValid extends False
      ? {
          [P in HavingFields]: P extends ByFields
            ? never
            : P extends string
            ? `Error: Field "${P}" used in "having" needs to be provided in "by".`
            : [
                Error,
                'Field ',
                P,
                ` in "having" needs to be provided in "by"`,
              ]
        }[HavingFields]
      : 'take' extends Keys<T>
      ? 'orderBy' extends Keys<T>
        ? ByValid extends True
          ? {}
          : {
              [P in OrderFields]: P extends ByFields
                ? never
                : `Error: Field "${P}" in "orderBy" needs to be provided in "by"`
            }[OrderFields]
        : 'Error: If you provide "take", you also need to provide "orderBy"'
      : 'skip' extends Keys<T>
      ? 'orderBy' extends Keys<T>
        ? ByValid extends True
          ? {}
          : {
              [P in OrderFields]: P extends ByFields
                ? never
                : `Error: Field "${P}" in "orderBy" needs to be provided in "by"`
            }[OrderFields]
        : 'Error: If you provide "skip", you also need to provide "orderBy"'
      : ByValid extends True
      ? {}
      : {
          [P in OrderFields]: P extends ByFields
            ? never
            : `Error: Field "${P}" in "orderBy" needs to be provided in "by"`
        }[OrderFields]
    >(args: SubsetIntersection<T, GroupGroupByArgs, OrderByArg> & InputErrors): {} extends InputErrors ? GetGroupGroupByPayload<T> : Prisma.PrismaPromise<InputErrors>
  /**
   * Fields of the Group model
   */
  readonly fields: GroupFieldRefs;
  }

  /**
   * The delegate class that acts as a "Promise-like" for Group.
   * Why is this prefixed with `Prisma__`?
   * Because we want to prevent naming conflicts as mentioned in
   * https://github.com/prisma/prisma-client-js/issues/707
   */
  export interface Prisma__GroupClient<T, Null = never, ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs, GlobalOmitOptions = {}> extends Prisma.PrismaPromise<T> {
    readonly [Symbol.toStringTag]: "PrismaPromise"
    appInstance<T extends AppInstanceDefaultArgs<ExtArgs> = {}>(args?: Subset<T, AppInstanceDefaultArgs<ExtArgs>>): Prisma__AppInstanceClient<$Result.GetResult<Prisma.$AppInstancePayload<ExtArgs>, T, "findUniqueOrThrow", GlobalOmitOptions> | Null, Null, ExtArgs, GlobalOmitOptions>
    faces<T extends Group$facesArgs<ExtArgs> = {}>(args?: Subset<T, Group$facesArgs<ExtArgs>>): Prisma.PrismaPromise<$Result.GetResult<Prisma.$FacePayload<ExtArgs>, T, "findMany", GlobalOmitOptions> | Null>
    /**
     * Attaches callbacks for the resolution and/or rejection of the Promise.
     * @param onfulfilled The callback to execute when the Promise is resolved.
     * @param onrejected The callback to execute when the Promise is rejected.
     * @returns A Promise for the completion of which ever callback is executed.
     */
    then<TResult1 = T, TResult2 = never>(onfulfilled?: ((value: T) => TResult1 | PromiseLike<TResult1>) | undefined | null, onrejected?: ((reason: any) => TResult2 | PromiseLike<TResult2>) | undefined | null): $Utils.JsPromise<TResult1 | TResult2>
    /**
     * Attaches a callback for only the rejection of the Promise.
     * @param onrejected The callback to execute when the Promise is rejected.
     * @returns A Promise for the completion of the callback.
     */
    catch<TResult = never>(onrejected?: ((reason: any) => TResult | PromiseLike<TResult>) | undefined | null): $Utils.JsPromise<T | TResult>
    /**
     * Attaches a callback that is invoked when the Promise is settled (fulfilled or rejected). The
     * resolved value cannot be modified from the callback.
     * @param onfinally The callback to execute when the Promise is settled (fulfilled or rejected).
     * @returns A Promise for the completion of the callback.
     */
    finally(onfinally?: (() => void) | undefined | null): $Utils.JsPromise<T>
  }




  /**
   * Fields of the Group model
   */
  interface GroupFieldRefs {
    readonly id: FieldRef<"Group", 'Int'>
    readonly appInstanceId: FieldRef<"Group", 'Int'>
    readonly name: FieldRef<"Group", 'String'>
    readonly createdAt: FieldRef<"Group", 'DateTime'>
  }
    

  // Custom InputTypes
  /**
   * Group findUnique
   */
  export type GroupFindUniqueArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the Group
     */
    select?: GroupSelect<ExtArgs> | null
    /**
     * Omit specific fields from the Group
     */
    omit?: GroupOmit<ExtArgs> | null
    /**
     * Choose, which related nodes to fetch as well
     */
    include?: GroupInclude<ExtArgs> | null
    /**
     * Filter, which Group to fetch.
     */
    where: GroupWhereUniqueInput
  }

  /**
   * Group findUniqueOrThrow
   */
  export type GroupFindUniqueOrThrowArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the Group
     */
    select?: GroupSelect<ExtArgs> | null
    /**
     * Omit specific fields from the Group
     */
    omit?: GroupOmit<ExtArgs> | null
    /**
     * Choose, which related nodes to fetch as well
     */
    include?: GroupInclude<ExtArgs> | null
    /**
     * Filter, which Group to fetch.
     */
    where: GroupWhereUniqueInput
  }

  /**
   * Group findFirst
   */
  export type GroupFindFirstArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the Group
     */
    select?: GroupSelect<ExtArgs> | null
    /**
     * Omit specific fields from the Group
     */
    omit?: GroupOmit<ExtArgs> | null
    /**
     * Choose, which related nodes to fetch as well
     */
    include?: GroupInclude<ExtArgs> | null
    /**
     * Filter, which Group to fetch.
     */
    where?: GroupWhereInput
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/sorting Sorting Docs}
     * 
     * Determine the order of Groups to fetch.
     */
    orderBy?: GroupOrderByWithRelationInput | GroupOrderByWithRelationInput[]
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination#cursor-based-pagination Cursor Docs}
     * 
     * Sets the position for searching for Groups.
     */
    cursor?: GroupWhereUniqueInput
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination Pagination Docs}
     * 
     * Take `±n` Groups from the position of the cursor.
     */
    take?: number
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination Pagination Docs}
     * 
     * Skip the first `n` Groups.
     */
    skip?: number
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/distinct Distinct Docs}
     * 
     * Filter by unique combinations of Groups.
     */
    distinct?: GroupScalarFieldEnum | GroupScalarFieldEnum[]
  }

  /**
   * Group findFirstOrThrow
   */
  export type GroupFindFirstOrThrowArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the Group
     */
    select?: GroupSelect<ExtArgs> | null
    /**
     * Omit specific fields from the Group
     */
    omit?: GroupOmit<ExtArgs> | null
    /**
     * Choose, which related nodes to fetch as well
     */
    include?: GroupInclude<ExtArgs> | null
    /**
     * Filter, which Group to fetch.
     */
    where?: GroupWhereInput
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/sorting Sorting Docs}
     * 
     * Determine the order of Groups to fetch.
     */
    orderBy?: GroupOrderByWithRelationInput | GroupOrderByWithRelationInput[]
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination#cursor-based-pagination Cursor Docs}
     * 
     * Sets the position for searching for Groups.
     */
    cursor?: GroupWhereUniqueInput
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination Pagination Docs}
     * 
     * Take `±n` Groups from the position of the cursor.
     */
    take?: number
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination Pagination Docs}
     * 
     * Skip the first `n` Groups.
     */
    skip?: number
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/distinct Distinct Docs}
     * 
     * Filter by unique combinations of Groups.
     */
    distinct?: GroupScalarFieldEnum | GroupScalarFieldEnum[]
  }

  /**
   * Group findMany
   */
  export type GroupFindManyArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the Group
     */
    select?: GroupSelect<ExtArgs> | null
    /**
     * Omit specific fields from the Group
     */
    omit?: GroupOmit<ExtArgs> | null
    /**
     * Choose, which related nodes to fetch as well
     */
    include?: GroupInclude<ExtArgs> | null
    /**
     * Filter, which Groups to fetch.
     */
    where?: GroupWhereInput
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/sorting Sorting Docs}
     * 
     * Determine the order of Groups to fetch.
     */
    orderBy?: GroupOrderByWithRelationInput | GroupOrderByWithRelationInput[]
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination#cursor-based-pagination Cursor Docs}
     * 
     * Sets the position for listing Groups.
     */
    cursor?: GroupWhereUniqueInput
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination Pagination Docs}
     * 
     * Take `±n` Groups from the position of the cursor.
     */
    take?: number
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination Pagination Docs}
     * 
     * Skip the first `n` Groups.
     */
    skip?: number
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/distinct Distinct Docs}
     * 
     * Filter by unique combinations of Groups.
     */
    distinct?: GroupScalarFieldEnum | GroupScalarFieldEnum[]
  }

  /**
   * Group create
   */
  export type GroupCreateArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the Group
     */
    select?: GroupSelect<ExtArgs> | null
    /**
     * Omit specific fields from the Group
     */
    omit?: GroupOmit<ExtArgs> | null
    /**
     * Choose, which related nodes to fetch as well
     */
    include?: GroupInclude<ExtArgs> | null
    /**
     * The data needed to create a Group.
     */
    data: XOR<GroupCreateInput, GroupUncheckedCreateInput>
  }

  /**
   * Group createMany
   */
  export type GroupCreateManyArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * The data used to create many Groups.
     */
    data: GroupCreateManyInput | GroupCreateManyInput[]
    skipDuplicates?: boolean
  }

  /**
   * Group update
   */
  export type GroupUpdateArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the Group
     */
    select?: GroupSelect<ExtArgs> | null
    /**
     * Omit specific fields from the Group
     */
    omit?: GroupOmit<ExtArgs> | null
    /**
     * Choose, which related nodes to fetch as well
     */
    include?: GroupInclude<ExtArgs> | null
    /**
     * The data needed to update a Group.
     */
    data: XOR<GroupUpdateInput, GroupUncheckedUpdateInput>
    /**
     * Choose, which Group to update.
     */
    where: GroupWhereUniqueInput
  }

  /**
   * Group updateMany
   */
  export type GroupUpdateManyArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * The data used to update Groups.
     */
    data: XOR<GroupUpdateManyMutationInput, GroupUncheckedUpdateManyInput>
    /**
     * Filter which Groups to update
     */
    where?: GroupWhereInput
    /**
     * Limit how many Groups to update.
     */
    limit?: number
  }

  /**
   * Group upsert
   */
  export type GroupUpsertArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the Group
     */
    select?: GroupSelect<ExtArgs> | null
    /**
     * Omit specific fields from the Group
     */
    omit?: GroupOmit<ExtArgs> | null
    /**
     * Choose, which related nodes to fetch as well
     */
    include?: GroupInclude<ExtArgs> | null
    /**
     * The filter to search for the Group to update in case it exists.
     */
    where: GroupWhereUniqueInput
    /**
     * In case the Group found by the `where` argument doesn't exist, create a new Group with this data.
     */
    create: XOR<GroupCreateInput, GroupUncheckedCreateInput>
    /**
     * In case the Group was found with the provided `where` argument, update it with this data.
     */
    update: XOR<GroupUpdateInput, GroupUncheckedUpdateInput>
  }

  /**
   * Group delete
   */
  export type GroupDeleteArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the Group
     */
    select?: GroupSelect<ExtArgs> | null
    /**
     * Omit specific fields from the Group
     */
    omit?: GroupOmit<ExtArgs> | null
    /**
     * Choose, which related nodes to fetch as well
     */
    include?: GroupInclude<ExtArgs> | null
    /**
     * Filter which Group to delete.
     */
    where: GroupWhereUniqueInput
  }

  /**
   * Group deleteMany
   */
  export type GroupDeleteManyArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Filter which Groups to delete
     */
    where?: GroupWhereInput
    /**
     * Limit how many Groups to delete.
     */
    limit?: number
  }

  /**
   * Group.faces
   */
  export type Group$facesArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the Face
     */
    select?: FaceSelect<ExtArgs> | null
    /**
     * Omit specific fields from the Face
     */
    omit?: FaceOmit<ExtArgs> | null
    /**
     * Choose, which related nodes to fetch as well
     */
    include?: FaceInclude<ExtArgs> | null
    where?: FaceWhereInput
    orderBy?: FaceOrderByWithRelationInput | FaceOrderByWithRelationInput[]
    cursor?: FaceWhereUniqueInput
    take?: number
    skip?: number
    distinct?: FaceScalarFieldEnum | FaceScalarFieldEnum[]
  }

  /**
   * Group without action
   */
  export type GroupDefaultArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the Group
     */
    select?: GroupSelect<ExtArgs> | null
    /**
     * Omit specific fields from the Group
     */
    omit?: GroupOmit<ExtArgs> | null
    /**
     * Choose, which related nodes to fetch as well
     */
    include?: GroupInclude<ExtArgs> | null
  }


  /**
   * Enums
   */

  export const TransactionIsolationLevel: {
    ReadUncommitted: 'ReadUncommitted',
    ReadCommitted: 'ReadCommitted',
    RepeatableRead: 'RepeatableRead',
    Serializable: 'Serializable'
  };

  export type TransactionIsolationLevel = (typeof TransactionIsolationLevel)[keyof typeof TransactionIsolationLevel]


  export const AppInstanceScalarFieldEnum: {
    id: 'id',
    createdAt: 'createdAt'
  };

  export type AppInstanceScalarFieldEnum = (typeof AppInstanceScalarFieldEnum)[keyof typeof AppInstanceScalarFieldEnum]


  export const PhotoScalarFieldEnum: {
    id: 'id',
    appInstanceId: 'appInstanceId',
    imagePath: 'imagePath',
    createdAt: 'createdAt'
  };

  export type PhotoScalarFieldEnum = (typeof PhotoScalarFieldEnum)[keyof typeof PhotoScalarFieldEnum]


  export const FaceScalarFieldEnum: {
    id: 'id',
    photoId: 'photoId',
    groupId: 'groupId',
    vector: 'vector',
    createdAt: 'createdAt'
  };

  export type FaceScalarFieldEnum = (typeof FaceScalarFieldEnum)[keyof typeof FaceScalarFieldEnum]


  export const GroupScalarFieldEnum: {
    id: 'id',
    appInstanceId: 'appInstanceId',
    name: 'name',
    createdAt: 'createdAt'
  };

  export type GroupScalarFieldEnum = (typeof GroupScalarFieldEnum)[keyof typeof GroupScalarFieldEnum]


  export const SortOrder: {
    asc: 'asc',
    desc: 'desc'
  };

  export type SortOrder = (typeof SortOrder)[keyof typeof SortOrder]


  export const JsonNullValueInput: {
    JsonNull: typeof JsonNull
  };

  export type JsonNullValueInput = (typeof JsonNullValueInput)[keyof typeof JsonNullValueInput]


  export const PhotoOrderByRelevanceFieldEnum: {
    imagePath: 'imagePath'
  };

  export type PhotoOrderByRelevanceFieldEnum = (typeof PhotoOrderByRelevanceFieldEnum)[keyof typeof PhotoOrderByRelevanceFieldEnum]


  export const JsonNullValueFilter: {
    DbNull: typeof DbNull,
    JsonNull: typeof JsonNull,
    AnyNull: typeof AnyNull
  };

  export type JsonNullValueFilter = (typeof JsonNullValueFilter)[keyof typeof JsonNullValueFilter]


  export const QueryMode: {
    default: 'default',
    insensitive: 'insensitive'
  };

  export type QueryMode = (typeof QueryMode)[keyof typeof QueryMode]


  export const NullsOrder: {
    first: 'first',
    last: 'last'
  };

  export type NullsOrder = (typeof NullsOrder)[keyof typeof NullsOrder]


  export const GroupOrderByRelevanceFieldEnum: {
    name: 'name'
  };

  export type GroupOrderByRelevanceFieldEnum = (typeof GroupOrderByRelevanceFieldEnum)[keyof typeof GroupOrderByRelevanceFieldEnum]


  /**
   * Field references
   */


  /**
   * Reference to a field of type 'Int'
   */
  export type IntFieldRefInput<$PrismaModel> = FieldRefInputType<$PrismaModel, 'Int'>
    


  /**
   * Reference to a field of type 'DateTime'
   */
  export type DateTimeFieldRefInput<$PrismaModel> = FieldRefInputType<$PrismaModel, 'DateTime'>
    


  /**
   * Reference to a field of type 'String'
   */
  export type StringFieldRefInput<$PrismaModel> = FieldRefInputType<$PrismaModel, 'String'>
    


  /**
   * Reference to a field of type 'Json'
   */
  export type JsonFieldRefInput<$PrismaModel> = FieldRefInputType<$PrismaModel, 'Json'>
    


  /**
   * Reference to a field of type 'QueryMode'
   */
  export type EnumQueryModeFieldRefInput<$PrismaModel> = FieldRefInputType<$PrismaModel, 'QueryMode'>
    


  /**
   * Reference to a field of type 'Float'
   */
  export type FloatFieldRefInput<$PrismaModel> = FieldRefInputType<$PrismaModel, 'Float'>
    
  /**
   * Deep Input Types
   */


  export type AppInstanceWhereInput = {
    AND?: AppInstanceWhereInput | AppInstanceWhereInput[]
    OR?: AppInstanceWhereInput[]
    NOT?: AppInstanceWhereInput | AppInstanceWhereInput[]
    id?: IntFilter<"AppInstance"> | number
    createdAt?: DateTimeFilter<"AppInstance"> | Date | string
    photos?: PhotoListRelationFilter
    groups?: GroupListRelationFilter
  }

  export type AppInstanceOrderByWithRelationInput = {
    id?: SortOrder
    createdAt?: SortOrder
    photos?: PhotoOrderByRelationAggregateInput
    groups?: GroupOrderByRelationAggregateInput
  }

  export type AppInstanceWhereUniqueInput = Prisma.AtLeast<{
    id?: number
    AND?: AppInstanceWhereInput | AppInstanceWhereInput[]
    OR?: AppInstanceWhereInput[]
    NOT?: AppInstanceWhereInput | AppInstanceWhereInput[]
    createdAt?: DateTimeFilter<"AppInstance"> | Date | string
    photos?: PhotoListRelationFilter
    groups?: GroupListRelationFilter
  }, "id">

  export type AppInstanceOrderByWithAggregationInput = {
    id?: SortOrder
    createdAt?: SortOrder
    _count?: AppInstanceCountOrderByAggregateInput
    _avg?: AppInstanceAvgOrderByAggregateInput
    _max?: AppInstanceMaxOrderByAggregateInput
    _min?: AppInstanceMinOrderByAggregateInput
    _sum?: AppInstanceSumOrderByAggregateInput
  }

  export type AppInstanceScalarWhereWithAggregatesInput = {
    AND?: AppInstanceScalarWhereWithAggregatesInput | AppInstanceScalarWhereWithAggregatesInput[]
    OR?: AppInstanceScalarWhereWithAggregatesInput[]
    NOT?: AppInstanceScalarWhereWithAggregatesInput | AppInstanceScalarWhereWithAggregatesInput[]
    id?: IntWithAggregatesFilter<"AppInstance"> | number
    createdAt?: DateTimeWithAggregatesFilter<"AppInstance"> | Date | string
  }

  export type PhotoWhereInput = {
    AND?: PhotoWhereInput | PhotoWhereInput[]
    OR?: PhotoWhereInput[]
    NOT?: PhotoWhereInput | PhotoWhereInput[]
    id?: IntFilter<"Photo"> | number
    appInstanceId?: IntFilter<"Photo"> | number
    imagePath?: StringFilter<"Photo"> | string
    createdAt?: DateTimeFilter<"Photo"> | Date | string
    appInstance?: XOR<AppInstanceScalarRelationFilter, AppInstanceWhereInput>
    faces?: FaceListRelationFilter
  }

  export type PhotoOrderByWithRelationInput = {
    id?: SortOrder
    appInstanceId?: SortOrder
    imagePath?: SortOrder
    createdAt?: SortOrder
    appInstance?: AppInstanceOrderByWithRelationInput
    faces?: FaceOrderByRelationAggregateInput
    _relevance?: PhotoOrderByRelevanceInput
  }

  export type PhotoWhereUniqueInput = Prisma.AtLeast<{
    id?: number
    AND?: PhotoWhereInput | PhotoWhereInput[]
    OR?: PhotoWhereInput[]
    NOT?: PhotoWhereInput | PhotoWhereInput[]
    appInstanceId?: IntFilter<"Photo"> | number
    imagePath?: StringFilter<"Photo"> | string
    createdAt?: DateTimeFilter<"Photo"> | Date | string
    appInstance?: XOR<AppInstanceScalarRelationFilter, AppInstanceWhereInput>
    faces?: FaceListRelationFilter
  }, "id">

  export type PhotoOrderByWithAggregationInput = {
    id?: SortOrder
    appInstanceId?: SortOrder
    imagePath?: SortOrder
    createdAt?: SortOrder
    _count?: PhotoCountOrderByAggregateInput
    _avg?: PhotoAvgOrderByAggregateInput
    _max?: PhotoMaxOrderByAggregateInput
    _min?: PhotoMinOrderByAggregateInput
    _sum?: PhotoSumOrderByAggregateInput
  }

  export type PhotoScalarWhereWithAggregatesInput = {
    AND?: PhotoScalarWhereWithAggregatesInput | PhotoScalarWhereWithAggregatesInput[]
    OR?: PhotoScalarWhereWithAggregatesInput[]
    NOT?: PhotoScalarWhereWithAggregatesInput | PhotoScalarWhereWithAggregatesInput[]
    id?: IntWithAggregatesFilter<"Photo"> | number
    appInstanceId?: IntWithAggregatesFilter<"Photo"> | number
    imagePath?: StringWithAggregatesFilter<"Photo"> | string
    createdAt?: DateTimeWithAggregatesFilter<"Photo"> | Date | string
  }

  export type FaceWhereInput = {
    AND?: FaceWhereInput | FaceWhereInput[]
    OR?: FaceWhereInput[]
    NOT?: FaceWhereInput | FaceWhereInput[]
    id?: IntFilter<"Face"> | number
    photoId?: IntFilter<"Face"> | number
    groupId?: IntNullableFilter<"Face"> | number | null
    vector?: JsonFilter<"Face">
    createdAt?: DateTimeFilter<"Face"> | Date | string
    photo?: XOR<PhotoScalarRelationFilter, PhotoWhereInput>
    group?: XOR<GroupNullableScalarRelationFilter, GroupWhereInput> | null
  }

  export type FaceOrderByWithRelationInput = {
    id?: SortOrder
    photoId?: SortOrder
    groupId?: SortOrderInput | SortOrder
    vector?: SortOrder
    createdAt?: SortOrder
    photo?: PhotoOrderByWithRelationInput
    group?: GroupOrderByWithRelationInput
  }

  export type FaceWhereUniqueInput = Prisma.AtLeast<{
    id?: number
    AND?: FaceWhereInput | FaceWhereInput[]
    OR?: FaceWhereInput[]
    NOT?: FaceWhereInput | FaceWhereInput[]
    photoId?: IntFilter<"Face"> | number
    groupId?: IntNullableFilter<"Face"> | number | null
    vector?: JsonFilter<"Face">
    createdAt?: DateTimeFilter<"Face"> | Date | string
    photo?: XOR<PhotoScalarRelationFilter, PhotoWhereInput>
    group?: XOR<GroupNullableScalarRelationFilter, GroupWhereInput> | null
  }, "id">

  export type FaceOrderByWithAggregationInput = {
    id?: SortOrder
    photoId?: SortOrder
    groupId?: SortOrderInput | SortOrder
    vector?: SortOrder
    createdAt?: SortOrder
    _count?: FaceCountOrderByAggregateInput
    _avg?: FaceAvgOrderByAggregateInput
    _max?: FaceMaxOrderByAggregateInput
    _min?: FaceMinOrderByAggregateInput
    _sum?: FaceSumOrderByAggregateInput
  }

  export type FaceScalarWhereWithAggregatesInput = {
    AND?: FaceScalarWhereWithAggregatesInput | FaceScalarWhereWithAggregatesInput[]
    OR?: FaceScalarWhereWithAggregatesInput[]
    NOT?: FaceScalarWhereWithAggregatesInput | FaceScalarWhereWithAggregatesInput[]
    id?: IntWithAggregatesFilter<"Face"> | number
    photoId?: IntWithAggregatesFilter<"Face"> | number
    groupId?: IntNullableWithAggregatesFilter<"Face"> | number | null
    vector?: JsonWithAggregatesFilter<"Face">
    createdAt?: DateTimeWithAggregatesFilter<"Face"> | Date | string
  }

  export type GroupWhereInput = {
    AND?: GroupWhereInput | GroupWhereInput[]
    OR?: GroupWhereInput[]
    NOT?: GroupWhereInput | GroupWhereInput[]
    id?: IntFilter<"Group"> | number
    appInstanceId?: IntFilter<"Group"> | number
    name?: StringFilter<"Group"> | string
    createdAt?: DateTimeFilter<"Group"> | Date | string
    appInstance?: XOR<AppInstanceScalarRelationFilter, AppInstanceWhereInput>
    faces?: FaceListRelationFilter
  }

  export type GroupOrderByWithRelationInput = {
    id?: SortOrder
    appInstanceId?: SortOrder
    name?: SortOrder
    createdAt?: SortOrder
    appInstance?: AppInstanceOrderByWithRelationInput
    faces?: FaceOrderByRelationAggregateInput
    _relevance?: GroupOrderByRelevanceInput
  }

  export type GroupWhereUniqueInput = Prisma.AtLeast<{
    id?: number
    appInstanceId_name?: GroupAppInstanceIdNameCompoundUniqueInput
    AND?: GroupWhereInput | GroupWhereInput[]
    OR?: GroupWhereInput[]
    NOT?: GroupWhereInput | GroupWhereInput[]
    appInstanceId?: IntFilter<"Group"> | number
    name?: StringFilter<"Group"> | string
    createdAt?: DateTimeFilter<"Group"> | Date | string
    appInstance?: XOR<AppInstanceScalarRelationFilter, AppInstanceWhereInput>
    faces?: FaceListRelationFilter
  }, "id" | "appInstanceId_name">

  export type GroupOrderByWithAggregationInput = {
    id?: SortOrder
    appInstanceId?: SortOrder
    name?: SortOrder
    createdAt?: SortOrder
    _count?: GroupCountOrderByAggregateInput
    _avg?: GroupAvgOrderByAggregateInput
    _max?: GroupMaxOrderByAggregateInput
    _min?: GroupMinOrderByAggregateInput
    _sum?: GroupSumOrderByAggregateInput
  }

  export type GroupScalarWhereWithAggregatesInput = {
    AND?: GroupScalarWhereWithAggregatesInput | GroupScalarWhereWithAggregatesInput[]
    OR?: GroupScalarWhereWithAggregatesInput[]
    NOT?: GroupScalarWhereWithAggregatesInput | GroupScalarWhereWithAggregatesInput[]
    id?: IntWithAggregatesFilter<"Group"> | number
    appInstanceId?: IntWithAggregatesFilter<"Group"> | number
    name?: StringWithAggregatesFilter<"Group"> | string
    createdAt?: DateTimeWithAggregatesFilter<"Group"> | Date | string
  }

  export type AppInstanceCreateInput = {
    createdAt?: Date | string
    photos?: PhotoCreateNestedManyWithoutAppInstanceInput
    groups?: GroupCreateNestedManyWithoutAppInstanceInput
  }

  export type AppInstanceUncheckedCreateInput = {
    id?: number
    createdAt?: Date | string
    photos?: PhotoUncheckedCreateNestedManyWithoutAppInstanceInput
    groups?: GroupUncheckedCreateNestedManyWithoutAppInstanceInput
  }

  export type AppInstanceUpdateInput = {
    createdAt?: DateTimeFieldUpdateOperationsInput | Date | string
    photos?: PhotoUpdateManyWithoutAppInstanceNestedInput
    groups?: GroupUpdateManyWithoutAppInstanceNestedInput
  }

  export type AppInstanceUncheckedUpdateInput = {
    id?: IntFieldUpdateOperationsInput | number
    createdAt?: DateTimeFieldUpdateOperationsInput | Date | string
    photos?: PhotoUncheckedUpdateManyWithoutAppInstanceNestedInput
    groups?: GroupUncheckedUpdateManyWithoutAppInstanceNestedInput
  }

  export type AppInstanceCreateManyInput = {
    id?: number
    createdAt?: Date | string
  }

  export type AppInstanceUpdateManyMutationInput = {
    createdAt?: DateTimeFieldUpdateOperationsInput | Date | string
  }

  export type AppInstanceUncheckedUpdateManyInput = {
    id?: IntFieldUpdateOperationsInput | number
    createdAt?: DateTimeFieldUpdateOperationsInput | Date | string
  }

  export type PhotoCreateInput = {
    imagePath: string
    createdAt?: Date | string
    appInstance: AppInstanceCreateNestedOneWithoutPhotosInput
    faces?: FaceCreateNestedManyWithoutPhotoInput
  }

  export type PhotoUncheckedCreateInput = {
    id?: number
    appInstanceId: number
    imagePath: string
    createdAt?: Date | string
    faces?: FaceUncheckedCreateNestedManyWithoutPhotoInput
  }

  export type PhotoUpdateInput = {
    imagePath?: StringFieldUpdateOperationsInput | string
    createdAt?: DateTimeFieldUpdateOperationsInput | Date | string
    appInstance?: AppInstanceUpdateOneRequiredWithoutPhotosNestedInput
    faces?: FaceUpdateManyWithoutPhotoNestedInput
  }

  export type PhotoUncheckedUpdateInput = {
    id?: IntFieldUpdateOperationsInput | number
    appInstanceId?: IntFieldUpdateOperationsInput | number
    imagePath?: StringFieldUpdateOperationsInput | string
    createdAt?: DateTimeFieldUpdateOperationsInput | Date | string
    faces?: FaceUncheckedUpdateManyWithoutPhotoNestedInput
  }

  export type PhotoCreateManyInput = {
    id?: number
    appInstanceId: number
    imagePath: string
    createdAt?: Date | string
  }

  export type PhotoUpdateManyMutationInput = {
    imagePath?: StringFieldUpdateOperationsInput | string
    createdAt?: DateTimeFieldUpdateOperationsInput | Date | string
  }

  export type PhotoUncheckedUpdateManyInput = {
    id?: IntFieldUpdateOperationsInput | number
    appInstanceId?: IntFieldUpdateOperationsInput | number
    imagePath?: StringFieldUpdateOperationsInput | string
    createdAt?: DateTimeFieldUpdateOperationsInput | Date | string
  }

  export type FaceCreateInput = {
    vector: JsonNullValueInput | InputJsonValue
    createdAt?: Date | string
    photo: PhotoCreateNestedOneWithoutFacesInput
    group?: GroupCreateNestedOneWithoutFacesInput
  }

  export type FaceUncheckedCreateInput = {
    id?: number
    photoId: number
    groupId?: number | null
    vector: JsonNullValueInput | InputJsonValue
    createdAt?: Date | string
  }

  export type FaceUpdateInput = {
    vector?: JsonNullValueInput | InputJsonValue
    createdAt?: DateTimeFieldUpdateOperationsInput | Date | string
    photo?: PhotoUpdateOneRequiredWithoutFacesNestedInput
    group?: GroupUpdateOneWithoutFacesNestedInput
  }

  export type FaceUncheckedUpdateInput = {
    id?: IntFieldUpdateOperationsInput | number
    photoId?: IntFieldUpdateOperationsInput | number
    groupId?: NullableIntFieldUpdateOperationsInput | number | null
    vector?: JsonNullValueInput | InputJsonValue
    createdAt?: DateTimeFieldUpdateOperationsInput | Date | string
  }

  export type FaceCreateManyInput = {
    id?: number
    photoId: number
    groupId?: number | null
    vector: JsonNullValueInput | InputJsonValue
    createdAt?: Date | string
  }

  export type FaceUpdateManyMutationInput = {
    vector?: JsonNullValueInput | InputJsonValue
    createdAt?: DateTimeFieldUpdateOperationsInput | Date | string
  }

  export type FaceUncheckedUpdateManyInput = {
    id?: IntFieldUpdateOperationsInput | number
    photoId?: IntFieldUpdateOperationsInput | number
    groupId?: NullableIntFieldUpdateOperationsInput | number | null
    vector?: JsonNullValueInput | InputJsonValue
    createdAt?: DateTimeFieldUpdateOperationsInput | Date | string
  }

  export type GroupCreateInput = {
    name: string
    createdAt?: Date | string
    appInstance: AppInstanceCreateNestedOneWithoutGroupsInput
    faces?: FaceCreateNestedManyWithoutGroupInput
  }

  export type GroupUncheckedCreateInput = {
    id?: number
    appInstanceId: number
    name: string
    createdAt?: Date | string
    faces?: FaceUncheckedCreateNestedManyWithoutGroupInput
  }

  export type GroupUpdateInput = {
    name?: StringFieldUpdateOperationsInput | string
    createdAt?: DateTimeFieldUpdateOperationsInput | Date | string
    appInstance?: AppInstanceUpdateOneRequiredWithoutGroupsNestedInput
    faces?: FaceUpdateManyWithoutGroupNestedInput
  }

  export type GroupUncheckedUpdateInput = {
    id?: IntFieldUpdateOperationsInput | number
    appInstanceId?: IntFieldUpdateOperationsInput | number
    name?: StringFieldUpdateOperationsInput | string
    createdAt?: DateTimeFieldUpdateOperationsInput | Date | string
    faces?: FaceUncheckedUpdateManyWithoutGroupNestedInput
  }

  export type GroupCreateManyInput = {
    id?: number
    appInstanceId: number
    name: string
    createdAt?: Date | string
  }

  export type GroupUpdateManyMutationInput = {
    name?: StringFieldUpdateOperationsInput | string
    createdAt?: DateTimeFieldUpdateOperationsInput | Date | string
  }

  export type GroupUncheckedUpdateManyInput = {
    id?: IntFieldUpdateOperationsInput | number
    appInstanceId?: IntFieldUpdateOperationsInput | number
    name?: StringFieldUpdateOperationsInput | string
    createdAt?: DateTimeFieldUpdateOperationsInput | Date | string
  }

  export type IntFilter<$PrismaModel = never> = {
    equals?: number | IntFieldRefInput<$PrismaModel>
    in?: number[]
    notIn?: number[]
    lt?: number | IntFieldRefInput<$PrismaModel>
    lte?: number | IntFieldRefInput<$PrismaModel>
    gt?: number | IntFieldRefInput<$PrismaModel>
    gte?: number | IntFieldRefInput<$PrismaModel>
    not?: NestedIntFilter<$PrismaModel> | number
  }

  export type DateTimeFilter<$PrismaModel = never> = {
    equals?: Date | string | DateTimeFieldRefInput<$PrismaModel>
    in?: Date[] | string[]
    notIn?: Date[] | string[]
    lt?: Date | string | DateTimeFieldRefInput<$PrismaModel>
    lte?: Date | string | DateTimeFieldRefInput<$PrismaModel>
    gt?: Date | string | DateTimeFieldRefInput<$PrismaModel>
    gte?: Date | string | DateTimeFieldRefInput<$PrismaModel>
    not?: NestedDateTimeFilter<$PrismaModel> | Date | string
  }

  export type PhotoListRelationFilter = {
    every?: PhotoWhereInput
    some?: PhotoWhereInput
    none?: PhotoWhereInput
  }

  export type GroupListRelationFilter = {
    every?: GroupWhereInput
    some?: GroupWhereInput
    none?: GroupWhereInput
  }

  export type PhotoOrderByRelationAggregateInput = {
    _count?: SortOrder
  }

  export type GroupOrderByRelationAggregateInput = {
    _count?: SortOrder
  }

  export type AppInstanceCountOrderByAggregateInput = {
    id?: SortOrder
    createdAt?: SortOrder
  }

  export type AppInstanceAvgOrderByAggregateInput = {
    id?: SortOrder
  }

  export type AppInstanceMaxOrderByAggregateInput = {
    id?: SortOrder
    createdAt?: SortOrder
  }

  export type AppInstanceMinOrderByAggregateInput = {
    id?: SortOrder
    createdAt?: SortOrder
  }

  export type AppInstanceSumOrderByAggregateInput = {
    id?: SortOrder
  }

  export type IntWithAggregatesFilter<$PrismaModel = never> = {
    equals?: number | IntFieldRefInput<$PrismaModel>
    in?: number[]
    notIn?: number[]
    lt?: number | IntFieldRefInput<$PrismaModel>
    lte?: number | IntFieldRefInput<$PrismaModel>
    gt?: number | IntFieldRefInput<$PrismaModel>
    gte?: number | IntFieldRefInput<$PrismaModel>
    not?: NestedIntWithAggregatesFilter<$PrismaModel> | number
    _count?: NestedIntFilter<$PrismaModel>
    _avg?: NestedFloatFilter<$PrismaModel>
    _sum?: NestedIntFilter<$PrismaModel>
    _min?: NestedIntFilter<$PrismaModel>
    _max?: NestedIntFilter<$PrismaModel>
  }

  export type DateTimeWithAggregatesFilter<$PrismaModel = never> = {
    equals?: Date | string | DateTimeFieldRefInput<$PrismaModel>
    in?: Date[] | string[]
    notIn?: Date[] | string[]
    lt?: Date | string | DateTimeFieldRefInput<$PrismaModel>
    lte?: Date | string | DateTimeFieldRefInput<$PrismaModel>
    gt?: Date | string | DateTimeFieldRefInput<$PrismaModel>
    gte?: Date | string | DateTimeFieldRefInput<$PrismaModel>
    not?: NestedDateTimeWithAggregatesFilter<$PrismaModel> | Date | string
    _count?: NestedIntFilter<$PrismaModel>
    _min?: NestedDateTimeFilter<$PrismaModel>
    _max?: NestedDateTimeFilter<$PrismaModel>
  }

  export type StringFilter<$PrismaModel = never> = {
    equals?: string | StringFieldRefInput<$PrismaModel>
    in?: string[]
    notIn?: string[]
    lt?: string | StringFieldRefInput<$PrismaModel>
    lte?: string | StringFieldRefInput<$PrismaModel>
    gt?: string | StringFieldRefInput<$PrismaModel>
    gte?: string | StringFieldRefInput<$PrismaModel>
    contains?: string | StringFieldRefInput<$PrismaModel>
    startsWith?: string | StringFieldRefInput<$PrismaModel>
    endsWith?: string | StringFieldRefInput<$PrismaModel>
    search?: string
    not?: NestedStringFilter<$PrismaModel> | string
  }

  export type AppInstanceScalarRelationFilter = {
    is?: AppInstanceWhereInput
    isNot?: AppInstanceWhereInput
  }

  export type FaceListRelationFilter = {
    every?: FaceWhereInput
    some?: FaceWhereInput
    none?: FaceWhereInput
  }

  export type FaceOrderByRelationAggregateInput = {
    _count?: SortOrder
  }

  export type PhotoOrderByRelevanceInput = {
    fields: PhotoOrderByRelevanceFieldEnum | PhotoOrderByRelevanceFieldEnum[]
    sort: SortOrder
    search: string
  }

  export type PhotoCountOrderByAggregateInput = {
    id?: SortOrder
    appInstanceId?: SortOrder
    imagePath?: SortOrder
    createdAt?: SortOrder
  }

  export type PhotoAvgOrderByAggregateInput = {
    id?: SortOrder
    appInstanceId?: SortOrder
  }

  export type PhotoMaxOrderByAggregateInput = {
    id?: SortOrder
    appInstanceId?: SortOrder
    imagePath?: SortOrder
    createdAt?: SortOrder
  }

  export type PhotoMinOrderByAggregateInput = {
    id?: SortOrder
    appInstanceId?: SortOrder
    imagePath?: SortOrder
    createdAt?: SortOrder
  }

  export type PhotoSumOrderByAggregateInput = {
    id?: SortOrder
    appInstanceId?: SortOrder
  }

  export type StringWithAggregatesFilter<$PrismaModel = never> = {
    equals?: string | StringFieldRefInput<$PrismaModel>
    in?: string[]
    notIn?: string[]
    lt?: string | StringFieldRefInput<$PrismaModel>
    lte?: string | StringFieldRefInput<$PrismaModel>
    gt?: string | StringFieldRefInput<$PrismaModel>
    gte?: string | StringFieldRefInput<$PrismaModel>
    contains?: string | StringFieldRefInput<$PrismaModel>
    startsWith?: string | StringFieldRefInput<$PrismaModel>
    endsWith?: string | StringFieldRefInput<$PrismaModel>
    search?: string
    not?: NestedStringWithAggregatesFilter<$PrismaModel> | string
    _count?: NestedIntFilter<$PrismaModel>
    _min?: NestedStringFilter<$PrismaModel>
    _max?: NestedStringFilter<$PrismaModel>
  }

  export type IntNullableFilter<$PrismaModel = never> = {
    equals?: number | IntFieldRefInput<$PrismaModel> | null
    in?: number[] | null
    notIn?: number[] | null
    lt?: number | IntFieldRefInput<$PrismaModel>
    lte?: number | IntFieldRefInput<$PrismaModel>
    gt?: number | IntFieldRefInput<$PrismaModel>
    gte?: number | IntFieldRefInput<$PrismaModel>
    not?: NestedIntNullableFilter<$PrismaModel> | number | null
  }
  export type JsonFilter<$PrismaModel = never> =
    | PatchUndefined<
        Either<Required<JsonFilterBase<$PrismaModel>>, Exclude<keyof Required<JsonFilterBase<$PrismaModel>>, 'path'>>,
        Required<JsonFilterBase<$PrismaModel>>
      >
    | OptionalFlat<Omit<Required<JsonFilterBase<$PrismaModel>>, 'path'>>

  export type JsonFilterBase<$PrismaModel = never> = {
    equals?: InputJsonValue | JsonFieldRefInput<$PrismaModel> | JsonNullValueFilter
    path?: string
    mode?: QueryMode | EnumQueryModeFieldRefInput<$PrismaModel>
    string_contains?: string | StringFieldRefInput<$PrismaModel>
    string_starts_with?: string | StringFieldRefInput<$PrismaModel>
    string_ends_with?: string | StringFieldRefInput<$PrismaModel>
    array_starts_with?: InputJsonValue | JsonFieldRefInput<$PrismaModel> | null
    array_ends_with?: InputJsonValue | JsonFieldRefInput<$PrismaModel> | null
    array_contains?: InputJsonValue | JsonFieldRefInput<$PrismaModel> | null
    lt?: InputJsonValue
    lte?: InputJsonValue
    gt?: InputJsonValue
    gte?: InputJsonValue
    not?: InputJsonValue | JsonFieldRefInput<$PrismaModel> | JsonNullValueFilter
  }

  export type PhotoScalarRelationFilter = {
    is?: PhotoWhereInput
    isNot?: PhotoWhereInput
  }

  export type GroupNullableScalarRelationFilter = {
    is?: GroupWhereInput | null
    isNot?: GroupWhereInput | null
  }

  export type SortOrderInput = {
    sort: SortOrder
    nulls?: NullsOrder
  }

  export type FaceCountOrderByAggregateInput = {
    id?: SortOrder
    photoId?: SortOrder
    groupId?: SortOrder
    vector?: SortOrder
    createdAt?: SortOrder
  }

  export type FaceAvgOrderByAggregateInput = {
    id?: SortOrder
    photoId?: SortOrder
    groupId?: SortOrder
  }

  export type FaceMaxOrderByAggregateInput = {
    id?: SortOrder
    photoId?: SortOrder
    groupId?: SortOrder
    createdAt?: SortOrder
  }

  export type FaceMinOrderByAggregateInput = {
    id?: SortOrder
    photoId?: SortOrder
    groupId?: SortOrder
    createdAt?: SortOrder
  }

  export type FaceSumOrderByAggregateInput = {
    id?: SortOrder
    photoId?: SortOrder
    groupId?: SortOrder
  }

  export type IntNullableWithAggregatesFilter<$PrismaModel = never> = {
    equals?: number | IntFieldRefInput<$PrismaModel> | null
    in?: number[] | null
    notIn?: number[] | null
    lt?: number | IntFieldRefInput<$PrismaModel>
    lte?: number | IntFieldRefInput<$PrismaModel>
    gt?: number | IntFieldRefInput<$PrismaModel>
    gte?: number | IntFieldRefInput<$PrismaModel>
    not?: NestedIntNullableWithAggregatesFilter<$PrismaModel> | number | null
    _count?: NestedIntNullableFilter<$PrismaModel>
    _avg?: NestedFloatNullableFilter<$PrismaModel>
    _sum?: NestedIntNullableFilter<$PrismaModel>
    _min?: NestedIntNullableFilter<$PrismaModel>
    _max?: NestedIntNullableFilter<$PrismaModel>
  }
  export type JsonWithAggregatesFilter<$PrismaModel = never> =
    | PatchUndefined<
        Either<Required<JsonWithAggregatesFilterBase<$PrismaModel>>, Exclude<keyof Required<JsonWithAggregatesFilterBase<$PrismaModel>>, 'path'>>,
        Required<JsonWithAggregatesFilterBase<$PrismaModel>>
      >
    | OptionalFlat<Omit<Required<JsonWithAggregatesFilterBase<$PrismaModel>>, 'path'>>

  export type JsonWithAggregatesFilterBase<$PrismaModel = never> = {
    equals?: InputJsonValue | JsonFieldRefInput<$PrismaModel> | JsonNullValueFilter
    path?: string
    mode?: QueryMode | EnumQueryModeFieldRefInput<$PrismaModel>
    string_contains?: string | StringFieldRefInput<$PrismaModel>
    string_starts_with?: string | StringFieldRefInput<$PrismaModel>
    string_ends_with?: string | StringFieldRefInput<$PrismaModel>
    array_starts_with?: InputJsonValue | JsonFieldRefInput<$PrismaModel> | null
    array_ends_with?: InputJsonValue | JsonFieldRefInput<$PrismaModel> | null
    array_contains?: InputJsonValue | JsonFieldRefInput<$PrismaModel> | null
    lt?: InputJsonValue
    lte?: InputJsonValue
    gt?: InputJsonValue
    gte?: InputJsonValue
    not?: InputJsonValue | JsonFieldRefInput<$PrismaModel> | JsonNullValueFilter
    _count?: NestedIntFilter<$PrismaModel>
    _min?: NestedJsonFilter<$PrismaModel>
    _max?: NestedJsonFilter<$PrismaModel>
  }

  export type GroupOrderByRelevanceInput = {
    fields: GroupOrderByRelevanceFieldEnum | GroupOrderByRelevanceFieldEnum[]
    sort: SortOrder
    search: string
  }

  export type GroupAppInstanceIdNameCompoundUniqueInput = {
    appInstanceId: number
    name: string
  }

  export type GroupCountOrderByAggregateInput = {
    id?: SortOrder
    appInstanceId?: SortOrder
    name?: SortOrder
    createdAt?: SortOrder
  }

  export type GroupAvgOrderByAggregateInput = {
    id?: SortOrder
    appInstanceId?: SortOrder
  }

  export type GroupMaxOrderByAggregateInput = {
    id?: SortOrder
    appInstanceId?: SortOrder
    name?: SortOrder
    createdAt?: SortOrder
  }

  export type GroupMinOrderByAggregateInput = {
    id?: SortOrder
    appInstanceId?: SortOrder
    name?: SortOrder
    createdAt?: SortOrder
  }

  export type GroupSumOrderByAggregateInput = {
    id?: SortOrder
    appInstanceId?: SortOrder
  }

  export type PhotoCreateNestedManyWithoutAppInstanceInput = {
    create?: XOR<PhotoCreateWithoutAppInstanceInput, PhotoUncheckedCreateWithoutAppInstanceInput> | PhotoCreateWithoutAppInstanceInput[] | PhotoUncheckedCreateWithoutAppInstanceInput[]
    connectOrCreate?: PhotoCreateOrConnectWithoutAppInstanceInput | PhotoCreateOrConnectWithoutAppInstanceInput[]
    createMany?: PhotoCreateManyAppInstanceInputEnvelope
    connect?: PhotoWhereUniqueInput | PhotoWhereUniqueInput[]
  }

  export type GroupCreateNestedManyWithoutAppInstanceInput = {
    create?: XOR<GroupCreateWithoutAppInstanceInput, GroupUncheckedCreateWithoutAppInstanceInput> | GroupCreateWithoutAppInstanceInput[] | GroupUncheckedCreateWithoutAppInstanceInput[]
    connectOrCreate?: GroupCreateOrConnectWithoutAppInstanceInput | GroupCreateOrConnectWithoutAppInstanceInput[]
    createMany?: GroupCreateManyAppInstanceInputEnvelope
    connect?: GroupWhereUniqueInput | GroupWhereUniqueInput[]
  }

  export type PhotoUncheckedCreateNestedManyWithoutAppInstanceInput = {
    create?: XOR<PhotoCreateWithoutAppInstanceInput, PhotoUncheckedCreateWithoutAppInstanceInput> | PhotoCreateWithoutAppInstanceInput[] | PhotoUncheckedCreateWithoutAppInstanceInput[]
    connectOrCreate?: PhotoCreateOrConnectWithoutAppInstanceInput | PhotoCreateOrConnectWithoutAppInstanceInput[]
    createMany?: PhotoCreateManyAppInstanceInputEnvelope
    connect?: PhotoWhereUniqueInput | PhotoWhereUniqueInput[]
  }

  export type GroupUncheckedCreateNestedManyWithoutAppInstanceInput = {
    create?: XOR<GroupCreateWithoutAppInstanceInput, GroupUncheckedCreateWithoutAppInstanceInput> | GroupCreateWithoutAppInstanceInput[] | GroupUncheckedCreateWithoutAppInstanceInput[]
    connectOrCreate?: GroupCreateOrConnectWithoutAppInstanceInput | GroupCreateOrConnectWithoutAppInstanceInput[]
    createMany?: GroupCreateManyAppInstanceInputEnvelope
    connect?: GroupWhereUniqueInput | GroupWhereUniqueInput[]
  }

  export type DateTimeFieldUpdateOperationsInput = {
    set?: Date | string
  }

  export type PhotoUpdateManyWithoutAppInstanceNestedInput = {
    create?: XOR<PhotoCreateWithoutAppInstanceInput, PhotoUncheckedCreateWithoutAppInstanceInput> | PhotoCreateWithoutAppInstanceInput[] | PhotoUncheckedCreateWithoutAppInstanceInput[]
    connectOrCreate?: PhotoCreateOrConnectWithoutAppInstanceInput | PhotoCreateOrConnectWithoutAppInstanceInput[]
    upsert?: PhotoUpsertWithWhereUniqueWithoutAppInstanceInput | PhotoUpsertWithWhereUniqueWithoutAppInstanceInput[]
    createMany?: PhotoCreateManyAppInstanceInputEnvelope
    set?: PhotoWhereUniqueInput | PhotoWhereUniqueInput[]
    disconnect?: PhotoWhereUniqueInput | PhotoWhereUniqueInput[]
    delete?: PhotoWhereUniqueInput | PhotoWhereUniqueInput[]
    connect?: PhotoWhereUniqueInput | PhotoWhereUniqueInput[]
    update?: PhotoUpdateWithWhereUniqueWithoutAppInstanceInput | PhotoUpdateWithWhereUniqueWithoutAppInstanceInput[]
    updateMany?: PhotoUpdateManyWithWhereWithoutAppInstanceInput | PhotoUpdateManyWithWhereWithoutAppInstanceInput[]
    deleteMany?: PhotoScalarWhereInput | PhotoScalarWhereInput[]
  }

  export type GroupUpdateManyWithoutAppInstanceNestedInput = {
    create?: XOR<GroupCreateWithoutAppInstanceInput, GroupUncheckedCreateWithoutAppInstanceInput> | GroupCreateWithoutAppInstanceInput[] | GroupUncheckedCreateWithoutAppInstanceInput[]
    connectOrCreate?: GroupCreateOrConnectWithoutAppInstanceInput | GroupCreateOrConnectWithoutAppInstanceInput[]
    upsert?: GroupUpsertWithWhereUniqueWithoutAppInstanceInput | GroupUpsertWithWhereUniqueWithoutAppInstanceInput[]
    createMany?: GroupCreateManyAppInstanceInputEnvelope
    set?: GroupWhereUniqueInput | GroupWhereUniqueInput[]
    disconnect?: GroupWhereUniqueInput | GroupWhereUniqueInput[]
    delete?: GroupWhereUniqueInput | GroupWhereUniqueInput[]
    connect?: GroupWhereUniqueInput | GroupWhereUniqueInput[]
    update?: GroupUpdateWithWhereUniqueWithoutAppInstanceInput | GroupUpdateWithWhereUniqueWithoutAppInstanceInput[]
    updateMany?: GroupUpdateManyWithWhereWithoutAppInstanceInput | GroupUpdateManyWithWhereWithoutAppInstanceInput[]
    deleteMany?: GroupScalarWhereInput | GroupScalarWhereInput[]
  }

  export type IntFieldUpdateOperationsInput = {
    set?: number
    increment?: number
    decrement?: number
    multiply?: number
    divide?: number
  }

  export type PhotoUncheckedUpdateManyWithoutAppInstanceNestedInput = {
    create?: XOR<PhotoCreateWithoutAppInstanceInput, PhotoUncheckedCreateWithoutAppInstanceInput> | PhotoCreateWithoutAppInstanceInput[] | PhotoUncheckedCreateWithoutAppInstanceInput[]
    connectOrCreate?: PhotoCreateOrConnectWithoutAppInstanceInput | PhotoCreateOrConnectWithoutAppInstanceInput[]
    upsert?: PhotoUpsertWithWhereUniqueWithoutAppInstanceInput | PhotoUpsertWithWhereUniqueWithoutAppInstanceInput[]
    createMany?: PhotoCreateManyAppInstanceInputEnvelope
    set?: PhotoWhereUniqueInput | PhotoWhereUniqueInput[]
    disconnect?: PhotoWhereUniqueInput | PhotoWhereUniqueInput[]
    delete?: PhotoWhereUniqueInput | PhotoWhereUniqueInput[]
    connect?: PhotoWhereUniqueInput | PhotoWhereUniqueInput[]
    update?: PhotoUpdateWithWhereUniqueWithoutAppInstanceInput | PhotoUpdateWithWhereUniqueWithoutAppInstanceInput[]
    updateMany?: PhotoUpdateManyWithWhereWithoutAppInstanceInput | PhotoUpdateManyWithWhereWithoutAppInstanceInput[]
    deleteMany?: PhotoScalarWhereInput | PhotoScalarWhereInput[]
  }

  export type GroupUncheckedUpdateManyWithoutAppInstanceNestedInput = {
    create?: XOR<GroupCreateWithoutAppInstanceInput, GroupUncheckedCreateWithoutAppInstanceInput> | GroupCreateWithoutAppInstanceInput[] | GroupUncheckedCreateWithoutAppInstanceInput[]
    connectOrCreate?: GroupCreateOrConnectWithoutAppInstanceInput | GroupCreateOrConnectWithoutAppInstanceInput[]
    upsert?: GroupUpsertWithWhereUniqueWithoutAppInstanceInput | GroupUpsertWithWhereUniqueWithoutAppInstanceInput[]
    createMany?: GroupCreateManyAppInstanceInputEnvelope
    set?: GroupWhereUniqueInput | GroupWhereUniqueInput[]
    disconnect?: GroupWhereUniqueInput | GroupWhereUniqueInput[]
    delete?: GroupWhereUniqueInput | GroupWhereUniqueInput[]
    connect?: GroupWhereUniqueInput | GroupWhereUniqueInput[]
    update?: GroupUpdateWithWhereUniqueWithoutAppInstanceInput | GroupUpdateWithWhereUniqueWithoutAppInstanceInput[]
    updateMany?: GroupUpdateManyWithWhereWithoutAppInstanceInput | GroupUpdateManyWithWhereWithoutAppInstanceInput[]
    deleteMany?: GroupScalarWhereInput | GroupScalarWhereInput[]
  }

  export type AppInstanceCreateNestedOneWithoutPhotosInput = {
    create?: XOR<AppInstanceCreateWithoutPhotosInput, AppInstanceUncheckedCreateWithoutPhotosInput>
    connectOrCreate?: AppInstanceCreateOrConnectWithoutPhotosInput
    connect?: AppInstanceWhereUniqueInput
  }

  export type FaceCreateNestedManyWithoutPhotoInput = {
    create?: XOR<FaceCreateWithoutPhotoInput, FaceUncheckedCreateWithoutPhotoInput> | FaceCreateWithoutPhotoInput[] | FaceUncheckedCreateWithoutPhotoInput[]
    connectOrCreate?: FaceCreateOrConnectWithoutPhotoInput | FaceCreateOrConnectWithoutPhotoInput[]
    createMany?: FaceCreateManyPhotoInputEnvelope
    connect?: FaceWhereUniqueInput | FaceWhereUniqueInput[]
  }

  export type FaceUncheckedCreateNestedManyWithoutPhotoInput = {
    create?: XOR<FaceCreateWithoutPhotoInput, FaceUncheckedCreateWithoutPhotoInput> | FaceCreateWithoutPhotoInput[] | FaceUncheckedCreateWithoutPhotoInput[]
    connectOrCreate?: FaceCreateOrConnectWithoutPhotoInput | FaceCreateOrConnectWithoutPhotoInput[]
    createMany?: FaceCreateManyPhotoInputEnvelope
    connect?: FaceWhereUniqueInput | FaceWhereUniqueInput[]
  }

  export type StringFieldUpdateOperationsInput = {
    set?: string
  }

  export type AppInstanceUpdateOneRequiredWithoutPhotosNestedInput = {
    create?: XOR<AppInstanceCreateWithoutPhotosInput, AppInstanceUncheckedCreateWithoutPhotosInput>
    connectOrCreate?: AppInstanceCreateOrConnectWithoutPhotosInput
    upsert?: AppInstanceUpsertWithoutPhotosInput
    connect?: AppInstanceWhereUniqueInput
    update?: XOR<XOR<AppInstanceUpdateToOneWithWhereWithoutPhotosInput, AppInstanceUpdateWithoutPhotosInput>, AppInstanceUncheckedUpdateWithoutPhotosInput>
  }

  export type FaceUpdateManyWithoutPhotoNestedInput = {
    create?: XOR<FaceCreateWithoutPhotoInput, FaceUncheckedCreateWithoutPhotoInput> | FaceCreateWithoutPhotoInput[] | FaceUncheckedCreateWithoutPhotoInput[]
    connectOrCreate?: FaceCreateOrConnectWithoutPhotoInput | FaceCreateOrConnectWithoutPhotoInput[]
    upsert?: FaceUpsertWithWhereUniqueWithoutPhotoInput | FaceUpsertWithWhereUniqueWithoutPhotoInput[]
    createMany?: FaceCreateManyPhotoInputEnvelope
    set?: FaceWhereUniqueInput | FaceWhereUniqueInput[]
    disconnect?: FaceWhereUniqueInput | FaceWhereUniqueInput[]
    delete?: FaceWhereUniqueInput | FaceWhereUniqueInput[]
    connect?: FaceWhereUniqueInput | FaceWhereUniqueInput[]
    update?: FaceUpdateWithWhereUniqueWithoutPhotoInput | FaceUpdateWithWhereUniqueWithoutPhotoInput[]
    updateMany?: FaceUpdateManyWithWhereWithoutPhotoInput | FaceUpdateManyWithWhereWithoutPhotoInput[]
    deleteMany?: FaceScalarWhereInput | FaceScalarWhereInput[]
  }

  export type FaceUncheckedUpdateManyWithoutPhotoNestedInput = {
    create?: XOR<FaceCreateWithoutPhotoInput, FaceUncheckedCreateWithoutPhotoInput> | FaceCreateWithoutPhotoInput[] | FaceUncheckedCreateWithoutPhotoInput[]
    connectOrCreate?: FaceCreateOrConnectWithoutPhotoInput | FaceCreateOrConnectWithoutPhotoInput[]
    upsert?: FaceUpsertWithWhereUniqueWithoutPhotoInput | FaceUpsertWithWhereUniqueWithoutPhotoInput[]
    createMany?: FaceCreateManyPhotoInputEnvelope
    set?: FaceWhereUniqueInput | FaceWhereUniqueInput[]
    disconnect?: FaceWhereUniqueInput | FaceWhereUniqueInput[]
    delete?: FaceWhereUniqueInput | FaceWhereUniqueInput[]
    connect?: FaceWhereUniqueInput | FaceWhereUniqueInput[]
    update?: FaceUpdateWithWhereUniqueWithoutPhotoInput | FaceUpdateWithWhereUniqueWithoutPhotoInput[]
    updateMany?: FaceUpdateManyWithWhereWithoutPhotoInput | FaceUpdateManyWithWhereWithoutPhotoInput[]
    deleteMany?: FaceScalarWhereInput | FaceScalarWhereInput[]
  }

  export type PhotoCreateNestedOneWithoutFacesInput = {
    create?: XOR<PhotoCreateWithoutFacesInput, PhotoUncheckedCreateWithoutFacesInput>
    connectOrCreate?: PhotoCreateOrConnectWithoutFacesInput
    connect?: PhotoWhereUniqueInput
  }

  export type GroupCreateNestedOneWithoutFacesInput = {
    create?: XOR<GroupCreateWithoutFacesInput, GroupUncheckedCreateWithoutFacesInput>
    connectOrCreate?: GroupCreateOrConnectWithoutFacesInput
    connect?: GroupWhereUniqueInput
  }

  export type PhotoUpdateOneRequiredWithoutFacesNestedInput = {
    create?: XOR<PhotoCreateWithoutFacesInput, PhotoUncheckedCreateWithoutFacesInput>
    connectOrCreate?: PhotoCreateOrConnectWithoutFacesInput
    upsert?: PhotoUpsertWithoutFacesInput
    connect?: PhotoWhereUniqueInput
    update?: XOR<XOR<PhotoUpdateToOneWithWhereWithoutFacesInput, PhotoUpdateWithoutFacesInput>, PhotoUncheckedUpdateWithoutFacesInput>
  }

  export type GroupUpdateOneWithoutFacesNestedInput = {
    create?: XOR<GroupCreateWithoutFacesInput, GroupUncheckedCreateWithoutFacesInput>
    connectOrCreate?: GroupCreateOrConnectWithoutFacesInput
    upsert?: GroupUpsertWithoutFacesInput
    disconnect?: GroupWhereInput | boolean
    delete?: GroupWhereInput | boolean
    connect?: GroupWhereUniqueInput
    update?: XOR<XOR<GroupUpdateToOneWithWhereWithoutFacesInput, GroupUpdateWithoutFacesInput>, GroupUncheckedUpdateWithoutFacesInput>
  }

  export type NullableIntFieldUpdateOperationsInput = {
    set?: number | null
    increment?: number
    decrement?: number
    multiply?: number
    divide?: number
  }

  export type AppInstanceCreateNestedOneWithoutGroupsInput = {
    create?: XOR<AppInstanceCreateWithoutGroupsInput, AppInstanceUncheckedCreateWithoutGroupsInput>
    connectOrCreate?: AppInstanceCreateOrConnectWithoutGroupsInput
    connect?: AppInstanceWhereUniqueInput
  }

  export type FaceCreateNestedManyWithoutGroupInput = {
    create?: XOR<FaceCreateWithoutGroupInput, FaceUncheckedCreateWithoutGroupInput> | FaceCreateWithoutGroupInput[] | FaceUncheckedCreateWithoutGroupInput[]
    connectOrCreate?: FaceCreateOrConnectWithoutGroupInput | FaceCreateOrConnectWithoutGroupInput[]
    createMany?: FaceCreateManyGroupInputEnvelope
    connect?: FaceWhereUniqueInput | FaceWhereUniqueInput[]
  }

  export type FaceUncheckedCreateNestedManyWithoutGroupInput = {
    create?: XOR<FaceCreateWithoutGroupInput, FaceUncheckedCreateWithoutGroupInput> | FaceCreateWithoutGroupInput[] | FaceUncheckedCreateWithoutGroupInput[]
    connectOrCreate?: FaceCreateOrConnectWithoutGroupInput | FaceCreateOrConnectWithoutGroupInput[]
    createMany?: FaceCreateManyGroupInputEnvelope
    connect?: FaceWhereUniqueInput | FaceWhereUniqueInput[]
  }

  export type AppInstanceUpdateOneRequiredWithoutGroupsNestedInput = {
    create?: XOR<AppInstanceCreateWithoutGroupsInput, AppInstanceUncheckedCreateWithoutGroupsInput>
    connectOrCreate?: AppInstanceCreateOrConnectWithoutGroupsInput
    upsert?: AppInstanceUpsertWithoutGroupsInput
    connect?: AppInstanceWhereUniqueInput
    update?: XOR<XOR<AppInstanceUpdateToOneWithWhereWithoutGroupsInput, AppInstanceUpdateWithoutGroupsInput>, AppInstanceUncheckedUpdateWithoutGroupsInput>
  }

  export type FaceUpdateManyWithoutGroupNestedInput = {
    create?: XOR<FaceCreateWithoutGroupInput, FaceUncheckedCreateWithoutGroupInput> | FaceCreateWithoutGroupInput[] | FaceUncheckedCreateWithoutGroupInput[]
    connectOrCreate?: FaceCreateOrConnectWithoutGroupInput | FaceCreateOrConnectWithoutGroupInput[]
    upsert?: FaceUpsertWithWhereUniqueWithoutGroupInput | FaceUpsertWithWhereUniqueWithoutGroupInput[]
    createMany?: FaceCreateManyGroupInputEnvelope
    set?: FaceWhereUniqueInput | FaceWhereUniqueInput[]
    disconnect?: FaceWhereUniqueInput | FaceWhereUniqueInput[]
    delete?: FaceWhereUniqueInput | FaceWhereUniqueInput[]
    connect?: FaceWhereUniqueInput | FaceWhereUniqueInput[]
    update?: FaceUpdateWithWhereUniqueWithoutGroupInput | FaceUpdateWithWhereUniqueWithoutGroupInput[]
    updateMany?: FaceUpdateManyWithWhereWithoutGroupInput | FaceUpdateManyWithWhereWithoutGroupInput[]
    deleteMany?: FaceScalarWhereInput | FaceScalarWhereInput[]
  }

  export type FaceUncheckedUpdateManyWithoutGroupNestedInput = {
    create?: XOR<FaceCreateWithoutGroupInput, FaceUncheckedCreateWithoutGroupInput> | FaceCreateWithoutGroupInput[] | FaceUncheckedCreateWithoutGroupInput[]
    connectOrCreate?: FaceCreateOrConnectWithoutGroupInput | FaceCreateOrConnectWithoutGroupInput[]
    upsert?: FaceUpsertWithWhereUniqueWithoutGroupInput | FaceUpsertWithWhereUniqueWithoutGroupInput[]
    createMany?: FaceCreateManyGroupInputEnvelope
    set?: FaceWhereUniqueInput | FaceWhereUniqueInput[]
    disconnect?: FaceWhereUniqueInput | FaceWhereUniqueInput[]
    delete?: FaceWhereUniqueInput | FaceWhereUniqueInput[]
    connect?: FaceWhereUniqueInput | FaceWhereUniqueInput[]
    update?: FaceUpdateWithWhereUniqueWithoutGroupInput | FaceUpdateWithWhereUniqueWithoutGroupInput[]
    updateMany?: FaceUpdateManyWithWhereWithoutGroupInput | FaceUpdateManyWithWhereWithoutGroupInput[]
    deleteMany?: FaceScalarWhereInput | FaceScalarWhereInput[]
  }

  export type NestedIntFilter<$PrismaModel = never> = {
    equals?: number | IntFieldRefInput<$PrismaModel>
    in?: number[]
    notIn?: number[]
    lt?: number | IntFieldRefInput<$PrismaModel>
    lte?: number | IntFieldRefInput<$PrismaModel>
    gt?: number | IntFieldRefInput<$PrismaModel>
    gte?: number | IntFieldRefInput<$PrismaModel>
    not?: NestedIntFilter<$PrismaModel> | number
  }

  export type NestedDateTimeFilter<$PrismaModel = never> = {
    equals?: Date | string | DateTimeFieldRefInput<$PrismaModel>
    in?: Date[] | string[]
    notIn?: Date[] | string[]
    lt?: Date | string | DateTimeFieldRefInput<$PrismaModel>
    lte?: Date | string | DateTimeFieldRefInput<$PrismaModel>
    gt?: Date | string | DateTimeFieldRefInput<$PrismaModel>
    gte?: Date | string | DateTimeFieldRefInput<$PrismaModel>
    not?: NestedDateTimeFilter<$PrismaModel> | Date | string
  }

  export type NestedIntWithAggregatesFilter<$PrismaModel = never> = {
    equals?: number | IntFieldRefInput<$PrismaModel>
    in?: number[]
    notIn?: number[]
    lt?: number | IntFieldRefInput<$PrismaModel>
    lte?: number | IntFieldRefInput<$PrismaModel>
    gt?: number | IntFieldRefInput<$PrismaModel>
    gte?: number | IntFieldRefInput<$PrismaModel>
    not?: NestedIntWithAggregatesFilter<$PrismaModel> | number
    _count?: NestedIntFilter<$PrismaModel>
    _avg?: NestedFloatFilter<$PrismaModel>
    _sum?: NestedIntFilter<$PrismaModel>
    _min?: NestedIntFilter<$PrismaModel>
    _max?: NestedIntFilter<$PrismaModel>
  }

  export type NestedFloatFilter<$PrismaModel = never> = {
    equals?: number | FloatFieldRefInput<$PrismaModel>
    in?: number[]
    notIn?: number[]
    lt?: number | FloatFieldRefInput<$PrismaModel>
    lte?: number | FloatFieldRefInput<$PrismaModel>
    gt?: number | FloatFieldRefInput<$PrismaModel>
    gte?: number | FloatFieldRefInput<$PrismaModel>
    not?: NestedFloatFilter<$PrismaModel> | number
  }

  export type NestedDateTimeWithAggregatesFilter<$PrismaModel = never> = {
    equals?: Date | string | DateTimeFieldRefInput<$PrismaModel>
    in?: Date[] | string[]
    notIn?: Date[] | string[]
    lt?: Date | string | DateTimeFieldRefInput<$PrismaModel>
    lte?: Date | string | DateTimeFieldRefInput<$PrismaModel>
    gt?: Date | string | DateTimeFieldRefInput<$PrismaModel>
    gte?: Date | string | DateTimeFieldRefInput<$PrismaModel>
    not?: NestedDateTimeWithAggregatesFilter<$PrismaModel> | Date | string
    _count?: NestedIntFilter<$PrismaModel>
    _min?: NestedDateTimeFilter<$PrismaModel>
    _max?: NestedDateTimeFilter<$PrismaModel>
  }

  export type NestedStringFilter<$PrismaModel = never> = {
    equals?: string | StringFieldRefInput<$PrismaModel>
    in?: string[]
    notIn?: string[]
    lt?: string | StringFieldRefInput<$PrismaModel>
    lte?: string | StringFieldRefInput<$PrismaModel>
    gt?: string | StringFieldRefInput<$PrismaModel>
    gte?: string | StringFieldRefInput<$PrismaModel>
    contains?: string | StringFieldRefInput<$PrismaModel>
    startsWith?: string | StringFieldRefInput<$PrismaModel>
    endsWith?: string | StringFieldRefInput<$PrismaModel>
    search?: string
    not?: NestedStringFilter<$PrismaModel> | string
  }

  export type NestedStringWithAggregatesFilter<$PrismaModel = never> = {
    equals?: string | StringFieldRefInput<$PrismaModel>
    in?: string[]
    notIn?: string[]
    lt?: string | StringFieldRefInput<$PrismaModel>
    lte?: string | StringFieldRefInput<$PrismaModel>
    gt?: string | StringFieldRefInput<$PrismaModel>
    gte?: string | StringFieldRefInput<$PrismaModel>
    contains?: string | StringFieldRefInput<$PrismaModel>
    startsWith?: string | StringFieldRefInput<$PrismaModel>
    endsWith?: string | StringFieldRefInput<$PrismaModel>
    search?: string
    not?: NestedStringWithAggregatesFilter<$PrismaModel> | string
    _count?: NestedIntFilter<$PrismaModel>
    _min?: NestedStringFilter<$PrismaModel>
    _max?: NestedStringFilter<$PrismaModel>
  }

  export type NestedIntNullableFilter<$PrismaModel = never> = {
    equals?: number | IntFieldRefInput<$PrismaModel> | null
    in?: number[] | null
    notIn?: number[] | null
    lt?: number | IntFieldRefInput<$PrismaModel>
    lte?: number | IntFieldRefInput<$PrismaModel>
    gt?: number | IntFieldRefInput<$PrismaModel>
    gte?: number | IntFieldRefInput<$PrismaModel>
    not?: NestedIntNullableFilter<$PrismaModel> | number | null
  }

  export type NestedIntNullableWithAggregatesFilter<$PrismaModel = never> = {
    equals?: number | IntFieldRefInput<$PrismaModel> | null
    in?: number[] | null
    notIn?: number[] | null
    lt?: number | IntFieldRefInput<$PrismaModel>
    lte?: number | IntFieldRefInput<$PrismaModel>
    gt?: number | IntFieldRefInput<$PrismaModel>
    gte?: number | IntFieldRefInput<$PrismaModel>
    not?: NestedIntNullableWithAggregatesFilter<$PrismaModel> | number | null
    _count?: NestedIntNullableFilter<$PrismaModel>
    _avg?: NestedFloatNullableFilter<$PrismaModel>
    _sum?: NestedIntNullableFilter<$PrismaModel>
    _min?: NestedIntNullableFilter<$PrismaModel>
    _max?: NestedIntNullableFilter<$PrismaModel>
  }

  export type NestedFloatNullableFilter<$PrismaModel = never> = {
    equals?: number | FloatFieldRefInput<$PrismaModel> | null
    in?: number[] | null
    notIn?: number[] | null
    lt?: number | FloatFieldRefInput<$PrismaModel>
    lte?: number | FloatFieldRefInput<$PrismaModel>
    gt?: number | FloatFieldRefInput<$PrismaModel>
    gte?: number | FloatFieldRefInput<$PrismaModel>
    not?: NestedFloatNullableFilter<$PrismaModel> | number | null
  }
  export type NestedJsonFilter<$PrismaModel = never> =
    | PatchUndefined<
        Either<Required<NestedJsonFilterBase<$PrismaModel>>, Exclude<keyof Required<NestedJsonFilterBase<$PrismaModel>>, 'path'>>,
        Required<NestedJsonFilterBase<$PrismaModel>>
      >
    | OptionalFlat<Omit<Required<NestedJsonFilterBase<$PrismaModel>>, 'path'>>

  export type NestedJsonFilterBase<$PrismaModel = never> = {
    equals?: InputJsonValue | JsonFieldRefInput<$PrismaModel> | JsonNullValueFilter
    path?: string
    mode?: QueryMode | EnumQueryModeFieldRefInput<$PrismaModel>
    string_contains?: string | StringFieldRefInput<$PrismaModel>
    string_starts_with?: string | StringFieldRefInput<$PrismaModel>
    string_ends_with?: string | StringFieldRefInput<$PrismaModel>
    array_starts_with?: InputJsonValue | JsonFieldRefInput<$PrismaModel> | null
    array_ends_with?: InputJsonValue | JsonFieldRefInput<$PrismaModel> | null
    array_contains?: InputJsonValue | JsonFieldRefInput<$PrismaModel> | null
    lt?: InputJsonValue
    lte?: InputJsonValue
    gt?: InputJsonValue
    gte?: InputJsonValue
    not?: InputJsonValue | JsonFieldRefInput<$PrismaModel> | JsonNullValueFilter
  }

  export type PhotoCreateWithoutAppInstanceInput = {
    imagePath: string
    createdAt?: Date | string
    faces?: FaceCreateNestedManyWithoutPhotoInput
  }

  export type PhotoUncheckedCreateWithoutAppInstanceInput = {
    id?: number
    imagePath: string
    createdAt?: Date | string
    faces?: FaceUncheckedCreateNestedManyWithoutPhotoInput
  }

  export type PhotoCreateOrConnectWithoutAppInstanceInput = {
    where: PhotoWhereUniqueInput
    create: XOR<PhotoCreateWithoutAppInstanceInput, PhotoUncheckedCreateWithoutAppInstanceInput>
  }

  export type PhotoCreateManyAppInstanceInputEnvelope = {
    data: PhotoCreateManyAppInstanceInput | PhotoCreateManyAppInstanceInput[]
    skipDuplicates?: boolean
  }

  export type GroupCreateWithoutAppInstanceInput = {
    name: string
    createdAt?: Date | string
    faces?: FaceCreateNestedManyWithoutGroupInput
  }

  export type GroupUncheckedCreateWithoutAppInstanceInput = {
    id?: number
    name: string
    createdAt?: Date | string
    faces?: FaceUncheckedCreateNestedManyWithoutGroupInput
  }

  export type GroupCreateOrConnectWithoutAppInstanceInput = {
    where: GroupWhereUniqueInput
    create: XOR<GroupCreateWithoutAppInstanceInput, GroupUncheckedCreateWithoutAppInstanceInput>
  }

  export type GroupCreateManyAppInstanceInputEnvelope = {
    data: GroupCreateManyAppInstanceInput | GroupCreateManyAppInstanceInput[]
    skipDuplicates?: boolean
  }

  export type PhotoUpsertWithWhereUniqueWithoutAppInstanceInput = {
    where: PhotoWhereUniqueInput
    update: XOR<PhotoUpdateWithoutAppInstanceInput, PhotoUncheckedUpdateWithoutAppInstanceInput>
    create: XOR<PhotoCreateWithoutAppInstanceInput, PhotoUncheckedCreateWithoutAppInstanceInput>
  }

  export type PhotoUpdateWithWhereUniqueWithoutAppInstanceInput = {
    where: PhotoWhereUniqueInput
    data: XOR<PhotoUpdateWithoutAppInstanceInput, PhotoUncheckedUpdateWithoutAppInstanceInput>
  }

  export type PhotoUpdateManyWithWhereWithoutAppInstanceInput = {
    where: PhotoScalarWhereInput
    data: XOR<PhotoUpdateManyMutationInput, PhotoUncheckedUpdateManyWithoutAppInstanceInput>
  }

  export type PhotoScalarWhereInput = {
    AND?: PhotoScalarWhereInput | PhotoScalarWhereInput[]
    OR?: PhotoScalarWhereInput[]
    NOT?: PhotoScalarWhereInput | PhotoScalarWhereInput[]
    id?: IntFilter<"Photo"> | number
    appInstanceId?: IntFilter<"Photo"> | number
    imagePath?: StringFilter<"Photo"> | string
    createdAt?: DateTimeFilter<"Photo"> | Date | string
  }

  export type GroupUpsertWithWhereUniqueWithoutAppInstanceInput = {
    where: GroupWhereUniqueInput
    update: XOR<GroupUpdateWithoutAppInstanceInput, GroupUncheckedUpdateWithoutAppInstanceInput>
    create: XOR<GroupCreateWithoutAppInstanceInput, GroupUncheckedCreateWithoutAppInstanceInput>
  }

  export type GroupUpdateWithWhereUniqueWithoutAppInstanceInput = {
    where: GroupWhereUniqueInput
    data: XOR<GroupUpdateWithoutAppInstanceInput, GroupUncheckedUpdateWithoutAppInstanceInput>
  }

  export type GroupUpdateManyWithWhereWithoutAppInstanceInput = {
    where: GroupScalarWhereInput
    data: XOR<GroupUpdateManyMutationInput, GroupUncheckedUpdateManyWithoutAppInstanceInput>
  }

  export type GroupScalarWhereInput = {
    AND?: GroupScalarWhereInput | GroupScalarWhereInput[]
    OR?: GroupScalarWhereInput[]
    NOT?: GroupScalarWhereInput | GroupScalarWhereInput[]
    id?: IntFilter<"Group"> | number
    appInstanceId?: IntFilter<"Group"> | number
    name?: StringFilter<"Group"> | string
    createdAt?: DateTimeFilter<"Group"> | Date | string
  }

  export type AppInstanceCreateWithoutPhotosInput = {
    createdAt?: Date | string
    groups?: GroupCreateNestedManyWithoutAppInstanceInput
  }

  export type AppInstanceUncheckedCreateWithoutPhotosInput = {
    id?: number
    createdAt?: Date | string
    groups?: GroupUncheckedCreateNestedManyWithoutAppInstanceInput
  }

  export type AppInstanceCreateOrConnectWithoutPhotosInput = {
    where: AppInstanceWhereUniqueInput
    create: XOR<AppInstanceCreateWithoutPhotosInput, AppInstanceUncheckedCreateWithoutPhotosInput>
  }

  export type FaceCreateWithoutPhotoInput = {
    vector: JsonNullValueInput | InputJsonValue
    createdAt?: Date | string
    group?: GroupCreateNestedOneWithoutFacesInput
  }

  export type FaceUncheckedCreateWithoutPhotoInput = {
    id?: number
    groupId?: number | null
    vector: JsonNullValueInput | InputJsonValue
    createdAt?: Date | string
  }

  export type FaceCreateOrConnectWithoutPhotoInput = {
    where: FaceWhereUniqueInput
    create: XOR<FaceCreateWithoutPhotoInput, FaceUncheckedCreateWithoutPhotoInput>
  }

  export type FaceCreateManyPhotoInputEnvelope = {
    data: FaceCreateManyPhotoInput | FaceCreateManyPhotoInput[]
    skipDuplicates?: boolean
  }

  export type AppInstanceUpsertWithoutPhotosInput = {
    update: XOR<AppInstanceUpdateWithoutPhotosInput, AppInstanceUncheckedUpdateWithoutPhotosInput>
    create: XOR<AppInstanceCreateWithoutPhotosInput, AppInstanceUncheckedCreateWithoutPhotosInput>
    where?: AppInstanceWhereInput
  }

  export type AppInstanceUpdateToOneWithWhereWithoutPhotosInput = {
    where?: AppInstanceWhereInput
    data: XOR<AppInstanceUpdateWithoutPhotosInput, AppInstanceUncheckedUpdateWithoutPhotosInput>
  }

  export type AppInstanceUpdateWithoutPhotosInput = {
    createdAt?: DateTimeFieldUpdateOperationsInput | Date | string
    groups?: GroupUpdateManyWithoutAppInstanceNestedInput
  }

  export type AppInstanceUncheckedUpdateWithoutPhotosInput = {
    id?: IntFieldUpdateOperationsInput | number
    createdAt?: DateTimeFieldUpdateOperationsInput | Date | string
    groups?: GroupUncheckedUpdateManyWithoutAppInstanceNestedInput
  }

  export type FaceUpsertWithWhereUniqueWithoutPhotoInput = {
    where: FaceWhereUniqueInput
    update: XOR<FaceUpdateWithoutPhotoInput, FaceUncheckedUpdateWithoutPhotoInput>
    create: XOR<FaceCreateWithoutPhotoInput, FaceUncheckedCreateWithoutPhotoInput>
  }

  export type FaceUpdateWithWhereUniqueWithoutPhotoInput = {
    where: FaceWhereUniqueInput
    data: XOR<FaceUpdateWithoutPhotoInput, FaceUncheckedUpdateWithoutPhotoInput>
  }

  export type FaceUpdateManyWithWhereWithoutPhotoInput = {
    where: FaceScalarWhereInput
    data: XOR<FaceUpdateManyMutationInput, FaceUncheckedUpdateManyWithoutPhotoInput>
  }

  export type FaceScalarWhereInput = {
    AND?: FaceScalarWhereInput | FaceScalarWhereInput[]
    OR?: FaceScalarWhereInput[]
    NOT?: FaceScalarWhereInput | FaceScalarWhereInput[]
    id?: IntFilter<"Face"> | number
    photoId?: IntFilter<"Face"> | number
    groupId?: IntNullableFilter<"Face"> | number | null
    vector?: JsonFilter<"Face">
    createdAt?: DateTimeFilter<"Face"> | Date | string
  }

  export type PhotoCreateWithoutFacesInput = {
    imagePath: string
    createdAt?: Date | string
    appInstance: AppInstanceCreateNestedOneWithoutPhotosInput
  }

  export type PhotoUncheckedCreateWithoutFacesInput = {
    id?: number
    appInstanceId: number
    imagePath: string
    createdAt?: Date | string
  }

  export type PhotoCreateOrConnectWithoutFacesInput = {
    where: PhotoWhereUniqueInput
    create: XOR<PhotoCreateWithoutFacesInput, PhotoUncheckedCreateWithoutFacesInput>
  }

  export type GroupCreateWithoutFacesInput = {
    name: string
    createdAt?: Date | string
    appInstance: AppInstanceCreateNestedOneWithoutGroupsInput
  }

  export type GroupUncheckedCreateWithoutFacesInput = {
    id?: number
    appInstanceId: number
    name: string
    createdAt?: Date | string
  }

  export type GroupCreateOrConnectWithoutFacesInput = {
    where: GroupWhereUniqueInput
    create: XOR<GroupCreateWithoutFacesInput, GroupUncheckedCreateWithoutFacesInput>
  }

  export type PhotoUpsertWithoutFacesInput = {
    update: XOR<PhotoUpdateWithoutFacesInput, PhotoUncheckedUpdateWithoutFacesInput>
    create: XOR<PhotoCreateWithoutFacesInput, PhotoUncheckedCreateWithoutFacesInput>
    where?: PhotoWhereInput
  }

  export type PhotoUpdateToOneWithWhereWithoutFacesInput = {
    where?: PhotoWhereInput
    data: XOR<PhotoUpdateWithoutFacesInput, PhotoUncheckedUpdateWithoutFacesInput>
  }

  export type PhotoUpdateWithoutFacesInput = {
    imagePath?: StringFieldUpdateOperationsInput | string
    createdAt?: DateTimeFieldUpdateOperationsInput | Date | string
    appInstance?: AppInstanceUpdateOneRequiredWithoutPhotosNestedInput
  }

  export type PhotoUncheckedUpdateWithoutFacesInput = {
    id?: IntFieldUpdateOperationsInput | number
    appInstanceId?: IntFieldUpdateOperationsInput | number
    imagePath?: StringFieldUpdateOperationsInput | string
    createdAt?: DateTimeFieldUpdateOperationsInput | Date | string
  }

  export type GroupUpsertWithoutFacesInput = {
    update: XOR<GroupUpdateWithoutFacesInput, GroupUncheckedUpdateWithoutFacesInput>
    create: XOR<GroupCreateWithoutFacesInput, GroupUncheckedCreateWithoutFacesInput>
    where?: GroupWhereInput
  }

  export type GroupUpdateToOneWithWhereWithoutFacesInput = {
    where?: GroupWhereInput
    data: XOR<GroupUpdateWithoutFacesInput, GroupUncheckedUpdateWithoutFacesInput>
  }

  export type GroupUpdateWithoutFacesInput = {
    name?: StringFieldUpdateOperationsInput | string
    createdAt?: DateTimeFieldUpdateOperationsInput | Date | string
    appInstance?: AppInstanceUpdateOneRequiredWithoutGroupsNestedInput
  }

  export type GroupUncheckedUpdateWithoutFacesInput = {
    id?: IntFieldUpdateOperationsInput | number
    appInstanceId?: IntFieldUpdateOperationsInput | number
    name?: StringFieldUpdateOperationsInput | string
    createdAt?: DateTimeFieldUpdateOperationsInput | Date | string
  }

  export type AppInstanceCreateWithoutGroupsInput = {
    createdAt?: Date | string
    photos?: PhotoCreateNestedManyWithoutAppInstanceInput
  }

  export type AppInstanceUncheckedCreateWithoutGroupsInput = {
    id?: number
    createdAt?: Date | string
    photos?: PhotoUncheckedCreateNestedManyWithoutAppInstanceInput
  }

  export type AppInstanceCreateOrConnectWithoutGroupsInput = {
    where: AppInstanceWhereUniqueInput
    create: XOR<AppInstanceCreateWithoutGroupsInput, AppInstanceUncheckedCreateWithoutGroupsInput>
  }

  export type FaceCreateWithoutGroupInput = {
    vector: JsonNullValueInput | InputJsonValue
    createdAt?: Date | string
    photo: PhotoCreateNestedOneWithoutFacesInput
  }

  export type FaceUncheckedCreateWithoutGroupInput = {
    id?: number
    photoId: number
    vector: JsonNullValueInput | InputJsonValue
    createdAt?: Date | string
  }

  export type FaceCreateOrConnectWithoutGroupInput = {
    where: FaceWhereUniqueInput
    create: XOR<FaceCreateWithoutGroupInput, FaceUncheckedCreateWithoutGroupInput>
  }

  export type FaceCreateManyGroupInputEnvelope = {
    data: FaceCreateManyGroupInput | FaceCreateManyGroupInput[]
    skipDuplicates?: boolean
  }

  export type AppInstanceUpsertWithoutGroupsInput = {
    update: XOR<AppInstanceUpdateWithoutGroupsInput, AppInstanceUncheckedUpdateWithoutGroupsInput>
    create: XOR<AppInstanceCreateWithoutGroupsInput, AppInstanceUncheckedCreateWithoutGroupsInput>
    where?: AppInstanceWhereInput
  }

  export type AppInstanceUpdateToOneWithWhereWithoutGroupsInput = {
    where?: AppInstanceWhereInput
    data: XOR<AppInstanceUpdateWithoutGroupsInput, AppInstanceUncheckedUpdateWithoutGroupsInput>
  }

  export type AppInstanceUpdateWithoutGroupsInput = {
    createdAt?: DateTimeFieldUpdateOperationsInput | Date | string
    photos?: PhotoUpdateManyWithoutAppInstanceNestedInput
  }

  export type AppInstanceUncheckedUpdateWithoutGroupsInput = {
    id?: IntFieldUpdateOperationsInput | number
    createdAt?: DateTimeFieldUpdateOperationsInput | Date | string
    photos?: PhotoUncheckedUpdateManyWithoutAppInstanceNestedInput
  }

  export type FaceUpsertWithWhereUniqueWithoutGroupInput = {
    where: FaceWhereUniqueInput
    update: XOR<FaceUpdateWithoutGroupInput, FaceUncheckedUpdateWithoutGroupInput>
    create: XOR<FaceCreateWithoutGroupInput, FaceUncheckedCreateWithoutGroupInput>
  }

  export type FaceUpdateWithWhereUniqueWithoutGroupInput = {
    where: FaceWhereUniqueInput
    data: XOR<FaceUpdateWithoutGroupInput, FaceUncheckedUpdateWithoutGroupInput>
  }

  export type FaceUpdateManyWithWhereWithoutGroupInput = {
    where: FaceScalarWhereInput
    data: XOR<FaceUpdateManyMutationInput, FaceUncheckedUpdateManyWithoutGroupInput>
  }

  export type PhotoCreateManyAppInstanceInput = {
    id?: number
    imagePath: string
    createdAt?: Date | string
  }

  export type GroupCreateManyAppInstanceInput = {
    id?: number
    name: string
    createdAt?: Date | string
  }

  export type PhotoUpdateWithoutAppInstanceInput = {
    imagePath?: StringFieldUpdateOperationsInput | string
    createdAt?: DateTimeFieldUpdateOperationsInput | Date | string
    faces?: FaceUpdateManyWithoutPhotoNestedInput
  }

  export type PhotoUncheckedUpdateWithoutAppInstanceInput = {
    id?: IntFieldUpdateOperationsInput | number
    imagePath?: StringFieldUpdateOperationsInput | string
    createdAt?: DateTimeFieldUpdateOperationsInput | Date | string
    faces?: FaceUncheckedUpdateManyWithoutPhotoNestedInput
  }

  export type PhotoUncheckedUpdateManyWithoutAppInstanceInput = {
    id?: IntFieldUpdateOperationsInput | number
    imagePath?: StringFieldUpdateOperationsInput | string
    createdAt?: DateTimeFieldUpdateOperationsInput | Date | string
  }

  export type GroupUpdateWithoutAppInstanceInput = {
    name?: StringFieldUpdateOperationsInput | string
    createdAt?: DateTimeFieldUpdateOperationsInput | Date | string
    faces?: FaceUpdateManyWithoutGroupNestedInput
  }

  export type GroupUncheckedUpdateWithoutAppInstanceInput = {
    id?: IntFieldUpdateOperationsInput | number
    name?: StringFieldUpdateOperationsInput | string
    createdAt?: DateTimeFieldUpdateOperationsInput | Date | string
    faces?: FaceUncheckedUpdateManyWithoutGroupNestedInput
  }

  export type GroupUncheckedUpdateManyWithoutAppInstanceInput = {
    id?: IntFieldUpdateOperationsInput | number
    name?: StringFieldUpdateOperationsInput | string
    createdAt?: DateTimeFieldUpdateOperationsInput | Date | string
  }

  export type FaceCreateManyPhotoInput = {
    id?: number
    groupId?: number | null
    vector: JsonNullValueInput | InputJsonValue
    createdAt?: Date | string
  }

  export type FaceUpdateWithoutPhotoInput = {
    vector?: JsonNullValueInput | InputJsonValue
    createdAt?: DateTimeFieldUpdateOperationsInput | Date | string
    group?: GroupUpdateOneWithoutFacesNestedInput
  }

  export type FaceUncheckedUpdateWithoutPhotoInput = {
    id?: IntFieldUpdateOperationsInput | number
    groupId?: NullableIntFieldUpdateOperationsInput | number | null
    vector?: JsonNullValueInput | InputJsonValue
    createdAt?: DateTimeFieldUpdateOperationsInput | Date | string
  }

  export type FaceUncheckedUpdateManyWithoutPhotoInput = {
    id?: IntFieldUpdateOperationsInput | number
    groupId?: NullableIntFieldUpdateOperationsInput | number | null
    vector?: JsonNullValueInput | InputJsonValue
    createdAt?: DateTimeFieldUpdateOperationsInput | Date | string
  }

  export type FaceCreateManyGroupInput = {
    id?: number
    photoId: number
    vector: JsonNullValueInput | InputJsonValue
    createdAt?: Date | string
  }

  export type FaceUpdateWithoutGroupInput = {
    vector?: JsonNullValueInput | InputJsonValue
    createdAt?: DateTimeFieldUpdateOperationsInput | Date | string
    photo?: PhotoUpdateOneRequiredWithoutFacesNestedInput
  }

  export type FaceUncheckedUpdateWithoutGroupInput = {
    id?: IntFieldUpdateOperationsInput | number
    photoId?: IntFieldUpdateOperationsInput | number
    vector?: JsonNullValueInput | InputJsonValue
    createdAt?: DateTimeFieldUpdateOperationsInput | Date | string
  }

  export type FaceUncheckedUpdateManyWithoutGroupInput = {
    id?: IntFieldUpdateOperationsInput | number
    photoId?: IntFieldUpdateOperationsInput | number
    vector?: JsonNullValueInput | InputJsonValue
    createdAt?: DateTimeFieldUpdateOperationsInput | Date | string
  }



  /**
   * Batch Payload for updateMany & deleteMany & createMany
   */

  export type BatchPayload = {
    count: number
  }

  /**
   * DMMF
   */
  export const dmmf: runtime.BaseDMMF
}